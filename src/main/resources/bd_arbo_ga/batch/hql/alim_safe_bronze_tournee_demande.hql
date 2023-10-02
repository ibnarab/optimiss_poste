USE ${database_safe};

INSERT INTO ${table_safe_tournee_demande}
SELECT DISTINCT
    routingid                                                        ,
    vehicles_vehicleid                                               ,
    vehicles_vehicle_description                                     ,
    vehicles_vehicle_moloc                                           ,
    vehicles_vehicle_carryingcapacity                                ,
    vehicles_vehicle_startroutecoordinates_gpslong                   ,
    vehicles_vehicle_startroutecoordinates_gpslat                    ,
    vehicles_vehicle_endroutecoordinates_gpslong                     ,
    vehicles_vehicle_endroutecoordinates_gpslat                      ,
    vehicles_vehicle_routetimeslot_starthour                         ,
    vehicles_vehicle_routetimeslot_endhour                           ,
    vehicles_vehicle_skills                                          ,
    routepoints_routepointid                                         ,
    routepoints_routepoint_description                               ,
    routepoints_routepoint_coordinates_gpslong                       ,
    routepoints_routepoint_coordinates_gpslat                        ,
    routepoints_routepoint_prioritylevel                             ,
    routepoints_routepoint_servicetime                               ,
    routepoints_routepoint_deliveryquantity                          ,
    routepoints_routepoint_pickupquantity                            ,
    routepoints_routepoint_timeslot_starthour                        ,
    routepoints_routepoint_timeslot_endhour                          ,
    routepoints_routepoint_skills                                    ,
    requestdatetime                                                  ,
    producer                                                         ,
    imeinumber                                                       ,
    mission_actorid                                                  ,
    regatecode                                                       ,
    date_import                                                       

FROM (
    SELECT *, MAX(requestdatetime) OVER (PARTITION BY (routingid, producer)) as max_requestdatetime
    FROM ${database_safe}.${table_safe_tournee_demande_deltas}
     ) a
WHERE a.requestdatetime = a.max_requestdatetime                      ;
