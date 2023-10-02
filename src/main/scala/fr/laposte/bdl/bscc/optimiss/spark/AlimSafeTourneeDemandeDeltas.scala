package fr.laposte.bdl.bscc.optimiss.spark

import fr.laposte.bdl.bscc.utlv4scala.UtlLogging
import fr.laposte.bdl.bscc.optimiss.common.AppConfig
import org.apache.spark.sql.SparkSession
import org.slf4j.{Logger, LoggerFactory}
import scala.util.Properties


/** Classe principale.
  *
  */
object AlimSafeTourneeDemandeDeltas extends SparkJob {

  // Data processing
   override def doit(spark: SparkSession): Unit = {
 
     // Class logs
     val logger : Logger = LoggerFactory.getLogger(getClass.getCanonicalName)
 
     // Loading the conf
     AppConfig.load()
 
     // Print the conf
     AppConfig.logInfo(logger)
 
     val firstDateToProcess : String = AppConfig.getFirstDateToProcess
     val lastDateToProcess  : String = AppConfig.getLastDateToprocess
     val targetRaw          : String = AppConfig.getTargetTableRawName
     val targetSafe       : String = AppConfig.getTargetSafeName
 
     val dfRaw     = spark.table(targetRaw)
     val dfSafe  = spark.table(targetSafe)
 
     // Filtrage des données selon la configuration
     val dfRecover = CommonMethods.filterByPeriod(logger, dfRaw, dfSafe, firstDateToProcess, lastDateToProcess)

         //explode array
         val dfExplode = CommonMethods.explodeDf(dfRecover)

         //drop Struct
         val dfDropStruct=CommonMethods.dropStruct(dfExplode)


     CommonMethods.appendData(spark, dfDropStruct, targetSafe)
   }


}
