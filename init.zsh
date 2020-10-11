######################################################################
#<
#
# Function: p6df::modules::oracle::version()
#
#>
######################################################################
p6df::modules::oracle::version() { echo "0.0.1" }

######################################################################
#<
#
# Function: p6df::modules::oracle::deps()
#
#>
######################################################################
p6df::modules::oracle::deps() {
	ModuleDeps=(
    p6m7g8/p6df-docker
    oracle/docker-images
  )
}

######################################################################
#<
#
# Function: p6df::modules::oracle::external::brew()
#
#>
######################################################################
p6df::modules::oracle::external::brew() {

  brew install InstantClientTap/instantclient/instantclient-sqlplus
  brew install InstantClientTap/instantclient/instantclient-tools
}

######################################################################
#<
#
# Function: p6df::modules::oracle::home::symlink()
#
#>
######################################################################
p6df::modules::oracle::home::symlink() {

}

######################################################################
#<
#
# Function: p6df::modules::oracle::init()
#
#>
######################################################################
p6df::modules::oracle::init() {

}

######################################################################
#<
#
# Function: p6df::modules::oracle::build()
#
#>
######################################################################
p6df::modules::oracle::build() {

  (
    cd $P6_DFZ_SRC_DIR/oracle/docker-images/OracleDatabase/SingleInstance/dockerfiles/18.4.0
    curl -sL -O https://p6df-assets.s3.us-east-2.amazonaws.com/oracle-database-xe-18c-1.0-1.x86_64.rpm
    cd ..
    ./buildDockerImage.sh -x -v 18.4.0
  )
}

######################################################################
#<
#
# Function: p6df::modules::oracle::run()
#
#>
######################################################################
p6df::modules::oracle::run() {

  local now_eps=$(p6_dt_now_epoch_seconds)

  docker run -d --name oracle-${now_eps} -e 'ACCEPT_EULA=Y' -e 'ORACLE_PWD=$ORACLE_PWD' -p 11521:11521 oracle/database:18.4.0-xe
}

######################################################################
#<
#
# Function: p6_sqlplus_as_system()
#
#>
######################################################################
p6_sqlplus_as_system() {

  sqlplus sys/testing12345@//localhost:11521/XE as sysdba "$@"
}