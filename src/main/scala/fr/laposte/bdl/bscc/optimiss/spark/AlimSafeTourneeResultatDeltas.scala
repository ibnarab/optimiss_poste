package fr.laposte.bdl.bscc.optimiss.spark

import fr.laposte.bdl.bscc.utlv4scala.UtlLogging
import fr.laposte.bdl.bscc.optimiss.common.AppConfig
import org.apache.spark.sql.SparkSession
import org.slf4j.{Logger, LoggerFactory}
import scala.util.Properties


/** Classe principale.
  *
  */
object AlimSafeTourneeResultatDeltas extends SparkJob {

  // Data processing
   override def doit(spark: SparkSession): Unit = {
 
     // Class logs
     val logger : Logger = LoggerFactory.getLogger(getClass.getCanonicalName)
 
     // Loading the conf
     AppConfig.load()
 
     // Print the conf
     AppConfig.logInfo(logger)
 
     val firstDateToProcess         : String = AppConfig.getFirstDateToProcess
     val lastDateToProcess          : String = AppConfig.getLastDateToprocess
     val targetResultatRaw          : String = AppConfig.getTargetTableResultatRawName
     val targetResultatSafe         : String = AppConfig.getTargetResultatSafeName

     val dfResultatRaw     = spark.table(targetResultatRaw)
     val dfResultatSafe    = spark.table(targetResultatSafe)

     // Filtrage des données resultat selon la configuration
     val dfRecoverResultat = CommonMethods.filterByPeriod(logger, dfResultatRaw, dfResultatSafe, firstDateToProcess, lastDateToProcess)

     //explode array resultat
     val dfExplodeResultat = CommonMethods.explodeResultatDf(dfRecoverResultat)

     //drop Struct
      val dfDropStructResultat=CommonMethods.dropStruct(dfExplodeResultat)

          CommonMethods.appendData(spark, dfDropStructResultat, targetResultatSafe)
   }


}
