package fr.laposte.bdl.bscc.optimiss.spark

import fr.laposte.bdl.bscc.optimiss.common.AppConfig
import fr.laposte.bdl.bscc.utlv4scala.UtlLogging
import org.apache.spark.sql.functions.{col, explode_outer, max, substring_index}
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}
import org.apache.spark.sql.SparkSession
import org.slf4j.{Logger, LoggerFactory}

/** Classe qui centralise les méthodes communes
  *
  */
object CommonMethods {

  /** Ajoute les données de la dataframe source dans la table cible
   * @param spark            SparkSession
   * @param dfSource         Dataframe source
   * @param targetTable      Au format "Database.table"
   */
  def appendData(spark: SparkSession, dfSource: DataFrame, targetTable: String): Unit = {
    val targetCols = spark.table(targetTable).columns
    dfSource.select(targetCols.head, targetCols.tail: _*)
      .write.mode(SaveMode.Append)
      .insertInto(targetTable)
  }


/**
   * Explode array of struct
   * explode_outer: on conserve les champs null
   * @param dfExtractSource Dataframe with extract cols
   * @return                       Dataframe with explode array
   */
  def explodeDf(dfSource: DataFrame): DataFrame = {
    dfSource
      .withColumn("vehicles",                                                             explode_outer(col("vehicles")))
      .withColumn("vehicles_vehicleid",                                                   col("vehicles.vehicleid"))
      .withColumn("vehicles_vehicle_description",                                         col("vehicles.vehicle_description"))
      .withColumn("vehicles_vehicle_moloc",                                               col("vehicles.vehicle_moloc"))
      .withColumn("vehicles_vehicle_carryingcapacity",                                    col("vehicles.vehicle_carryingcapacity"))
      .withColumn("vehicles_vehicle_startroutecoordinates_gpslong",                       col("vehicles.vehicle_startroutecoordinates.gpslong"))
      .withColumn("vehicles_vehicle_startroutecoordinates_gpslat",                        col("vehicles.vehicle_startroutecoordinates.gpslat"))
      .withColumn("vehicles_vehicle_endroutecoordinates_gpslong",                         col("vehicles.vehicle_endroutecoordinates.gpslong"))
      .withColumn("vehicles_vehicle_endroutecoordinates_gpslat",                          col("vehicles.vehicle_endroutecoordinates.gpslat"))
      .withColumn("vehicles_vehicle_routetimeslot_starthour",                             col("vehicles.vehicle_routetimeslot.starthour"))
      .withColumn("vehicles_vehicle_routetimeslot_endhour",                               col("vehicles.vehicle_routetimeslot.endhour"))
      .withColumn("vehicles_vehicle_skills",                                              explode_outer(col("vehicles.vehicle_skills")))
      .withColumn("routepoints",                                                          explode_outer(col("routepoints")))
      .withColumn("routepoints_routepointid",                                             col("routepoints.routepointid"))
      .withColumn("routepoints_routepoint_description",                                   col("routepoints.routepoint_description"))
      .withColumn("routepoints_routepoint_coordinates_gpslong",                           col("routepoints.routepoint_coordinates.gpslong"))
      .withColumn("routepoints_routepoint_coordinates_gpslat",                            col("routepoints.routepoint_coordinates.gpslat"))
      .withColumn("routepoints_routepoint_prioritylevel",                                 col("routepoints.routepoint_prioritylevel"))
      .withColumn("routepoints_routepoint_servicetime",                                   col("routepoints.routepoint_servicetime"))
      .withColumn("routepoints_routepoint_deliveryquantity",                              col("routepoints.routepoint_deliveryquantity"))
      .withColumn("routepoints_routepoint_pickupquantity",                                col("routepoints.routepoint_pickupquantity"))
      .withColumn("routepoints_routepoint_timeslot_starthour",                            col("routepoints.routepoint_timeslot.starthour"))
      .withColumn("routepoints_routepoint_timeslot_endhour",                              col("routepoints.routepoint_timeslot.endhour"))
      .withColumn("routepoints_routepoint_skills",                                         explode_outer(col("routepoints.routepoint_skills")))
  }

/**
   * Explode array of struct
   * explode_outer: on conserve les champs null
   * @param dfExtractSource Dataframe with extract cols
   * @return                       Dataframe with explode array
   */
  def explodeResultatDf(dfSource: DataFrame): DataFrame = {
    dfSource
      .withColumn("routes",                                                               explode_outer(col("routes")))
      .withColumn("routes_vehicleid",                                                     col("routes.vehicleid"))
      .withColumn("routes_vehicle_description",                                           col("routes.vehicle_description"))
      .withColumn("routes_routepoints",                                                   explode_outer(col("routes.routepoints")))
      .withColumn("routes_routepoints_type",                                              col("routes_routepoints.type"))
      .withColumn("routes_routepoints_routepointid",                                      col("routes_routepoints.routepointid"))
      .withColumn("routes_routepoints_indicdeliverytime",                                 col("routes_routepoints.indicdeliverytime"))
      .withColumn("unassignedroutepoints",                                                explode_outer(col("unassignedroutepoints")))
      .withColumn("unassignedroutepoints_routepointid",                                   col("unassignedroutepoints.routepointid"))
      .withColumn("unassignedroutepoints_type",                                           col("unassignedroutepoints.type"))

  }

  /**
     * Drop initial cols
     * @param dfDrop  Dataframe with explode array
     * @return                     Dataframe without initial cols
     */
    def dropStruct(dfSource: DataFrame): DataFrame = {
      dfSource.drop( "vehicles","routepoints")
    }

    def dropStructResultat(dfSource: DataFrame): DataFrame = {
          dfSource.drop( "routes","unassignedroutepoints","routes_routepoints")
        }

  /**
   * Supprime les colonnes demandées de la dataframe source
   * @param dfSource dataframe source
   * @param columnsToDrop liste des colonnes à supprimer
   * @return nouvelle dataframe
   */
  def dropColumns(dfSource: DataFrame, columnsToDrop: List[String]): DataFrame = {
    var dfTarget = dfSource
    columnsToDrop.foreach { columnName =>
      dfTarget = dfTarget.drop(col(columnName))
    }
    dfTarget
  }

  /**
   * Retourne le nom de la colonne et son alias d'après la chaine ou le tuple en paramètre.
   * Si l'alias n'est pas spécifié, il sera égal au nom de la colonne
   * @param columnNameOrAlias chaine indiquant le nom de la colonne ou tuple(nomColonne, alias)
   */
  def getColumnNameAndAlias(columnNameOrAlias: Any): (String, String) = {
    columnNameOrAlias match {
      case (sourceName: String, aliasName: String) => (sourceName, aliasName)
      case sourceName:String => (sourceName, sourceName)
    }
  }

  /**
   * Retourne vrai si la liste en paramètre contient la colonne en paramètre.
   * @param columnsWithOptionalAlias liste des configurations de colonnes (avec ou sans alias)
   * @param value nom de la colonne à tester
   */
  def listNameOrAliasContains(columnsWithOptionalAlias: List[Any], value: String): Boolean = {
    val results = columnsWithOptionalAlias.filter { columnNameOrAlias =>
      val (sourceColumnName, _) = getColumnNameAndAlias(columnNameOrAlias)
      sourceColumnName == value
    }
    results.nonEmpty
  }

  /**
   * Crée une colonne utilisée pour le partitionnement depuis un champ de type String représentant une date au format YYYY-MM-DD
   * @param dfSource dataframe source
   * @param columnSourceName nom de la colonne à utiliser
   * @param columnTargetName nom de la colonne en sortie
   * @return nouvelle dataframe
   */
  def createPartitionColumn(dfSource: DataFrame, columnSourceName: String, columnTargetName: String): DataFrame = {
    dfSource.withColumn(columnTargetName, substring_index(col(columnSourceName), "-", 2))
  }

  /**
   * Filtre les lignes de la dataframe source selon la date d'import et la période de date souhaitée. <br>
   * Si la dataframe cible est vide, aucun filtre n'est appliqué sur la source.<br>
   * Si aucune période n'est explicitement demandée, filtre la source pour ne conserver que les nouvelles lignes
   * depuis la date la plus récente de la dataframe cible.
   *
   * @return dataframe source filtrée
   */
  def filterByPeriod(logger: Logger, dfSource: DataFrame, dfTarget: DataFrame, firstDateToProcess: String = "", lastDateToProcess: String = ""): DataFrame = {
    if (dfTarget.limit(1).count() == 0) {
      logger.info("INFO_LOG, First alimentation")
      dfSource
    } else if ((firstDateToProcess != "") && (lastDateToProcess != "")) {
      logger.info("INFO_LOG, Manual alimentation")
      logger.info("INFO_LOG, first_date_to_process = " + firstDateToProcess)
      logger.info("INFO_LOG, last_date_to_process = " + lastDateToProcess)
      dfSource.filter(col(AppConfig.DateImportColumnName) >= firstDateToProcess && col(AppConfig.DateImportColumnName) <= lastDateToProcess)
    } else {
      logger.info("INFO_LOG, Automatic alimentation")
      val maxDate = dfTarget.select(max(AppConfig.DateImportColumnName)).collect().map(_.getString(0)).mkString(" ")
      dfSource.filter(col(AppConfig.DateImportColumnName) > maxDate)
    }
  }

}
