USE ${database};

DROP TABLE IF EXISTS ${table};

CREATE EXTERNAL TABLE ${table}
(
    routingid                                                               STRING  COMMENT 'Permet de fixer un identifiant d optimisation'                                                                                                             ,
    producer                                                                STRING  COMMENT 'code producer de l emetteur de la demande'                                                                                                                 ,
    requestdatetime                                                         STRING  COMMENT 'Date heure de la demande'                                                                                                                                  ,
    vehicles_vehicleid                                                      STRING  COMMENT 'Identifiant de la demande d optimisation pour la tournee'                                                                                                  ,
    vehicle_description                                                     STRING  COMMENT 'Breve description de la tournee'                                                                                                                           ,
    request_vehicles_vehicle_moloc                                          STRING  COMMENT 'Moyen de locomotion de la tournee'                                                                                                                         ,
    request_vehicles_vehicle_carryingcapacity                               INT     COMMENT 'Capacite du moyen de locomotion (meme unite que les volumes a collecter/livrer sur le job)'                                                                ,
    request_vehicles_vehicle_startroutecoordinates_gpslong                  STRING  COMMENT 'Coordonnees du point de depart de la tournee'                                                                                                              ,
    request_vehicles_vehicle_startroutecoordinates_gpslat                   STRING  COMMENT 'Coordonnees du point de depart de la tournee'                                                                                                              ,
    request_vehicles_vehicle_endroutecoordinates_gpslong                    STRING  COMMENT 'Coordonnees du point d arrivee de la tournee'                                                                                                              ,
    request_vehicles_vehicle_endroutecoordinates_gpslat                     STRING  COMMENT 'Coordonnees du point d arrivee de la tournee'                                                                                                              ,
    request_vehicles_vehicle_routetimeslot_starthour                        INT     COMMENT 'Heure de debut au format int (nombre de secondes apres minuit)'                                                                                            ,
    request_vehicles_vehicle_routetimeslot_endhour                          INT     COMMENT 'Heure de fin au format int (nombre de secondes apres minuit)'                                                                                              ,
    routepoints_routepointid                                                STRING  COMMENT 'Identifiant unique du point de passage (job)'                                                                                                              ,
    request_routepoints_routepoint_description                              STRING  COMMENT 'Breve description du job'                                                                                                                                  ,
    request_routepoints_routepoint_coordinates_gpslong                      STRING  COMMENT 'Coordonnees du point de passage'                                                                                                                           ,
    request_routepoints_routepoint_coordinates_gpslat                       STRING  COMMENT 'Coordonnees du point de passage'                                                                                                                           ,
    request_routepoints_routepoint_prioritylevel                            INT     COMMENT 'Niveau de priorite du point de passage (a reverifier)'                                                                                                     ,
    request_routepoints_routepoint_servicetime                              INT     COMMENT 'Duree du service sur le point de passage (unite: nombre de secondes apres minuit)'                                                                         ,
    request_routepoints_routepoint_deliveryquantity                         INT     COMMENT 'Volume a livrer'                                                                                                                                           ,
    request_routepoints_routepoint_pickupquantity                           INT     COMMENT 'Volume a collecter'                                                                                                                                        ,
    request_routepoints_routepoint_timeslot_starthour                       INT     COMMENT 'Heure de debut de la plage horaire de passage souhaite'                                                                                                    ,
    request_routepoints_routepoint_timeslot_endhour                         INT     COMMENT 'Heure de fin de la plage horaire de passage souhaite'                                                                                                      ,
    request_imeinumber                                                      STRING  COMMENT 'IMEI pour International Mobile Equipment Identity de l emetteur de la demande'                                                                             ,
    request_mission_actorid                                                 STRING  COMMENT 'code RH de l utilisateur emetteur de la demande'                                                                                                           ,
    request_regatecode                                                      STRING  COMMENT 'code REGATE de l utilisateur emetteur de la demande'                                                                                                       ,
    result_routes_routepoints_type                                          STRING  COMMENT 'Type du point (soit startRoute: point de depart de l itineraire, soit routePoint: un point de passage, soit endRoute: point d arrivee de l itineraire)'    ,
    result_routes_routepoints_indicdeliverytime                             INT     COMMENT 'La HIP, l heure indicative de passage (en nombre de secondes depuis minuit)'                                                                               ,
    result_flag_unassigned_routepointid                                     INT     COMMENT 'flag permettant de distinguer les points de passage pris en compte ou non dans le calcul d`optimisation'                                                   ,
    result_code                                                             INT     COMMENT 'Code retour de l optimisation (0 = OK et Autre valeur = traitement KO)'                                                                                    ,
    result_error                                                            STRING  COMMENT 'Motif pour laquelle l optimisation est KO. Presente uniquement en cas d erreur'
)
COMMENT 'Optimized tournee distribution'
STORED AS PARQUET
LOCATION '${hdfs_path}';

ALTER TABLE ${table}
ADD CONSTRAINT pk_${table} PRIMARY KEY (routingid, producer, vehicles_vehicleid, routepoints_routepointid)
disable novalidate;
