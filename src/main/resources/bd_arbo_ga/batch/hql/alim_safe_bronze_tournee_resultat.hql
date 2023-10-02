USE ${database_safe};

INSERT INTO ${table_safe_tournee_resultat}
SELECT DISTINCT
    routingid                                                        ,
    routes_vehicleid                                                 ,
    routes_vehicle_description                                       ,
    routes_routepoints_type                                          ,
    routes_routepoints_routepointid                                  ,
    routes_routepoints_indicdeliverytime                             ,
    unassignedroutepoints_routepointid                               ,
    unassignedroutepoints_type                                       ,
    code                                                             ,
    error                                                            ,
    producer                                                         ,
    date_import

FROM ${database_safe}.${table_safe_tournee_resultat_deltas}          ;
