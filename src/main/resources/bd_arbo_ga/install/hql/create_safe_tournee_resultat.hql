USE ${database};

DROP TABLE IF EXISTS ${table};

CREATE EXTERNAL TABLE ${table}
(
    routingid                                                        STRING    COMMENT 'Permet de rappeler l`identifiant d`optimisation fournit dans le topic in'                                                                                   ,
    routes_vehicleid                                                 STRING    COMMENT 'Identifiant du vehicule retenu pour l`itineraire'                                                                                                           ,
    routes_vehicle_description                                       STRING    COMMENT 'Breve description du vehicule'                                                                                                                              ,
    routes_routepoints_type                                          STRING    COMMENT 'Type du point (soit startRoute: point de depart de l`itineraire, soit routePoint: un point de passage, soit endRoute: point d`arrivee de l`itineraire)'     ,
    routes_routepoints_routepointid                                  STRING    COMMENT 'Identifiant du point de passage (non renseigne pour les types start et end, mais systematiquement fourni pour un point de type routePoint)'                 ,
    routes_routepoints_indicdeliverytime                             INT       COMMENT 'La HIP, l`heure indicative de passage (en nombre de secondes depuis minuit)'                                                                                ,
    unassignedroutepoints_routepointid                               STRING    COMMENT 'Identifiant du point non optimise'                                                                                                                          ,
    unassignedroutepoints_type                                       STRING    COMMENT 'Type du point routePoint'                                                                                                                                   ,
    code                                                             INT       COMMENT 'Code retour de l`optimisation (0 = OK et Autre valeur = traitement KO)'                                                                                     ,
    error                                                            STRING    COMMENT 'Motif pour laquelle l`optimisation est KO. Presente uniquement en cas d`erreur'                                                                             ,
    producer                                                         STRING    COMMENT 'code producer de l`emetteur de la demande'                                                                                                                  ,
    date_import                                                      STRING    COMMENT 'Date import'
)
COMMENT 'routing result'
STORED AS PARQUET
LOCATION '${hdfs_path}';

ALTER TABLE ${table}
ADD CONSTRAINT pk_${table} PRIMARY KEY (routingid, producer)
disable novalidate;

