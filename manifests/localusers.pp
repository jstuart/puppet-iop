# Wrapper around the creation of local users and groups
class iop::localusers (
  $enable_group_hadoop   = true,
  $enable_user_ambari_qa = true,
  $enable_user_ams       = true,
  $enable_user_flume     = true,
  $enable_user_hbase     = true,
  $enable_user_hcat      = true,
  $enable_user_hdfs      = true,
  $enable_user_hive      = true,
  $enable_user_kafka     = true,
  $enable_user_knox      = true,
  $enable_user_mapred    = true,
  $enable_user_oozie     = true,
  $enable_user_solr      = true,
  $enable_user_spark     = true,
  $enable_user_sqoop     = true,
  $enable_user_yarn      = true,
  $enable_user_zookeeper = true,
) {
  # Users cannot exist without this...
  if $enable_group_hadoop {
    require iop::groups::hadoop
    
    if $enable_user_ambari_qa {
      require iop::users::ambari_qa
    }
    
    if $enable_user_ams {
      require iop::users::ams
    }
    
    if $enable_user_flume {
      require iop::users::flume
    }
    
    if $enable_user_hbase {
      require iop::users::hbase
    }
    
    if $enable_user_hcat {
      require iop::users::hcat
    }
    
    if $enable_user_hdfs {
      require iop::users::hdfs
    }
    
    if $enable_user_hive {
      require iop::users::hive
    }
    
    if $enable_user_kafka {
      require iop::users::kafka
    }
    
    if $enable_user_knox {
      require iop::users::knox
    }
        
    if $enable_user_mapred {
      require iop::users::mapred
    }
        
    if $enable_user_oozie {
      require iop::users::oozie
    }
        
    if $enable_user_solr {
      require iop::users::solr
    }
        
    if $enable_user_spark {
      require iop::users::spark
    }
        
    if $enable_user_sqoop {
      require iop::users::sqoop
    }
    
    if $enable_user_yarn {
      require iop::users::yarn
    }
    
    if $enable_user_zookeeper {
      require iop::users::zookeeper
    }
  }
}