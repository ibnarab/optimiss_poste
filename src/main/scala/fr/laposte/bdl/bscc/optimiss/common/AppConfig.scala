package fr.laposte.bdl.bscc.optimiss.common

import fr.laposte.bdl.bscc.utlv4scala.UtlConfig
import org.slf4j.Logger


/** Classe de gestion de la configuration applicative.
  *
  */
object AppConfig {

  // charger la conf
  def load() : Unit = {
    UtlConfig.load()
  }

  // tout logguer en niveau "info"
  def logInfo(logger: Logger) : Unit =  {
    UtlConfig.logInfo(logger, "app")
  }

 val Undefined: String = "<undefined>"
   val TableNameSeparator: String = "."
   val DateImportColumnName: String = "date_import"
 
 
   // Recover info
   def getFirstDateToProcess: String                     = UtlConfig.get("app.optimiss.first_date_to_process","")
   def getLastDateToprocess: String                      = UtlConfig.get("app.optimiss.last_date_to_process","")
 
   // Raw info
   def getDatabaseRawName: String                        = UtlConfig.get("app.database.raw", Undefined)

       //Raw tournee_demande
       def getTableRawName: String                           = UtlConfig.get("app.table.raw.routingrequest", Undefined)
       def getTargetTableRawName: String                     = getDatabaseRawName + TableNameSeparator + getTableRawName

      //Raw tournee_resultat
       def getTableResultatRawName: String                    = UtlConfig.get("app.table.raw.routingresult", Undefined)
       def getTargetTableResultatRawName: String              = getDatabaseRawName + TableNameSeparator + getTableResultatRawName


   // Safe
   def getDatabaseSafeName: String                       = UtlConfig.get("app.database.safe", Undefined)

    // Safe tournee demande
   def getTableSafeName: String                          = UtlConfig.get("app.table.safe.bronze.tournee_demande_deltas", Undefined)
   def getTargetSafeName: String                         = getDatabaseSafeName + TableNameSeparator + getTableSafeName

    // Safe tournee resultat
       def getTableResultatSafeName: String              = UtlConfig.get("app.table.safe.bronze.tournee_resultat_deltas", Undefined)
       def getTargetResultatSafeName: String             = getDatabaseSafeName + TableNameSeparator + getTableResultatSafeName

}
