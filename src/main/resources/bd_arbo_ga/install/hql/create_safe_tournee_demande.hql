USE ${database};

DROP TABLE IF EXISTS ${table};

CREATE EXTERNAL TABLE ${table}
(
    routingid                                                        STRING  COMMENT 'Permet de fixer un identifiant d optimisation'                                                    ,
    vehicles_vehicleid                                               STRING  COMMENT 'Identifiant de la demande d optimisation pour la tournee'                                         ,
    vehicles_vehicle_description                                     STRING  COMMENT 'Breve description de la tournee'                                                                  ,
    vehicles_vehicle_moloc                                           STRING  COMMENT 'Moyen de locomotion de la tournee'                                                                ,
    vehicles_vehicle_carryingcapacity                                INT     COMMENT 'Capacite du moyen de locomotion (meme unite que les volumes a collecter/livrer sur le job)'       ,
    vehicles_vehicle_startroutecoordinates_gpslong                   STRING  COMMENT 'Coordonnees du point de depart de la tournee'                                                     ,
    vehicles_vehicle_startroutecoordinates_gpslat                    STRING  COMMENT 'Coordonnees du point de depart de la tournee'                                                     ,
    vehicles_vehicle_endroutecoordinates_gpslong                     STRING  COMMENT 'Coordonnees du point d arrivee de la tournee'                                                     ,
    vehicles_vehicle_endroutecoordinates_gpslat                      STRING  COMMENT 'Coordonnees du point d arrivee de la tournee'                                                     ,
    vehicles_vehicle_routetimeslot_starthour                         INT     COMMENT 'Heure de debut au format int (nombre de secondes apres minuit)'                                   ,
    vehicles_vehicle_routetimeslot_endhour                           INT     COMMENT 'Heure de fin au format int (nombre de secondes apres minuit)'                                     ,
    vehicles_vehicle_skills                                          INT     COMMENT 'Indique les compétences de la tournée'                                                            ,
    routepoints_routepointid                                         STRING  COMMENT 'Identifiant unique du point de passage (job)'                                                     ,
    routepoints_routepoint_description                               STRING  COMMENT 'Breve description du job'                                                                         ,
    routepoints_routepoint_coordinates_gpslong                       STRING  COMMENT 'Coordonnees du point de passage'                                                                  ,
    routepoints_routepoint_coordinates_gpslat                        STRING  COMMENT 'Coordonnees du point de passage'                                                                  ,
    routepoints_routepoint_prioritylevel                             INT     COMMENT 'Niveau de priorite du point de passage (a reverifier)'                                            ,
    routepoints_routepoint_servicetime                               INT     COMMENT 'Duree du service sur le point de passage (unite: nombre de secondes apres minuit)'                ,
    routepoints_routepoint_deliveryquantity                          INT     COMMENT 'Volume a livrer'                                                                                  ,
    routepoints_routepoint_pickupquantity                            INT     COMMENT 'Volume a collecter'                                                                               ,
    routepoints_routepoint_timeslot_starthour                        INT     COMMENT 'Plage horaire de passage souhaite'                                                                ,
    routepoints_routepoint_timeslot_endhour                          INT     COMMENT 'Plage horaire de passage souhaite'                                                                ,
    routepoints_routepoint_skills                                    INT     COMMENT 'Competences necessaires pour le point de passage'                                                 ,
    requestdatetime                                                  STRING  COMMENT 'Date heure de la demande'                                                                         ,
    producer                                                         STRING  COMMENT 'code producer de l emetteur de la demande'                                                        ,
    imeinumber                                                       STRING  COMMENT 'IMEI pour International Mobile Equipment Identity de l emetteur de la demande'                    ,
    mission_actorid                                                  STRING  COMMENT 'code RH de l utilisateur emetteur de la demande'                                                  ,
    regatecode                                                       STRING  COMMENT 'code REGATE de l utilisateur emetteur de la demande'                                              ,
    date_import                                                      STRING  COMMENT 'Date de l import'

)
COMMENT 'routing request'
STORED AS PARQUET
LOCATION '${hdfs_path}';

ALTER TABLE ${table}
ADD CONSTRAINT pk_${table} PRIMARY KEY (routingid, producer)
disable novalidate;

