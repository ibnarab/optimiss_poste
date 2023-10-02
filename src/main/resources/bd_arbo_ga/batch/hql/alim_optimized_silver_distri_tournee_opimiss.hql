USE ${database_optimized};

INSERT INTO ${table_optimized_tournee_optimiss}
SELECT
     b.routingid                                                                                                                                                                                   ,
     b.producer                                                                                                                                                                                    ,
     b.requestdatetime                                                                                                                                                                             ,
     b.vehicles_vehicleid                                                                                                                                                                          ,
     b.vehicles_vehicle_description                                                                                                  AS vehicle_description                                        ,
     b.vehicles_vehicle_moloc                                                                                                        AS request_vehicles_vehicle_moloc                             ,
     b.vehicles_vehicle_carryingcapacity                                                                                             AS request_vehicles_vehicle_carryingcapacity                  ,
     b.vehicles_vehicle_startroutecoordinates_gpslong                                                                                AS request_vehicles_vehicle_startroutecoordinates_gpslong     ,
     b.vehicles_vehicle_startroutecoordinates_gpslat                                                                                 AS request_vehicles_vehicle_startroutecoordinates_gpslat      ,
     b.vehicles_vehicle_endroutecoordinates_gpslong                                                                                  AS request_vehicles_vehicle_endroutecoordinates_gpslong       ,
     b.vehicles_vehicle_endroutecoordinates_gpslat                                                                                   AS request_vehicles_vehicle_endroutecoordinates_gpslat        ,
     b.vehicles_vehicle_routetimeslot_starthour                                                                                      AS request_vehicles_vehicle_routetimeslot_starthour           ,
     b.vehicles_vehicle_routetimeslot_endhour                                                                                        AS request_vehicles_vehicle_routetimeslot_endhour             ,
     CASE WHEN a.routes_routepoints_type = 'routePoint' THEN b.routepoints_routepointid ELSE   a.routes_routepoints_routepointid END AS routepoints_routepointid                                   ,
     b.routepoints_routepoint_description                                                                                            AS request_routepoints_routepoint_description                 ,
     b.routepoints_routepoint_coordinates_gpslong                                                                                    AS request_routepoints_routepoint_coordinates_gpslong         ,
     b.routepoints_routepoint_coordinates_gpslat                                                                                     AS request_routepoints_routepoint_coordinates_gpslat          ,
     b.routepoints_routepoint_prioritylevel                                                                                          AS request_routepoints_routepoint_prioritylevel               ,
     b.routepoints_routepoint_servicetime                                                                                            AS request_routepoints_routepoint_servicetime                 ,
     b.routepoints_routepoint_deliveryquantity                                                                                       AS request_routepoints_routepoint_deliveryquantity            ,
     b.routepoints_routepoint_pickupquantity                                                                                         AS request_routepoints_routepoint_pickupquantity              ,
     b.routepoints_routepoint_timeslot_starthour                                                                                     AS request_routepoints_routepoint_timeslot_starthour          ,
     b.routepoints_routepoint_timeslot_endhour                                                                                       AS request_routepoints_routepoint_timeslot_endhour            ,
     CASE WHEN b.imeinumber      IS NOT NULL THEN 'Présent' ELSE 'Absent' END                                                        AS request_imeinumber                                         ,
     CASE WHEN b.mission_actorid IS NOT NULL THEN 'Présent' ELSE 'Absent' END                                                        AS request_mission_actorid                                    ,
     b.regatecode                                                                                                                    AS request_regatecode                                         ,
     a.routes_routepoints_type                                                                                                       AS result_routes_routepoints_type                             ,
     a.routes_routepoints_indicdeliverytime                                                                                          AS result_routes_routepoints_indicdeliverytime                ,
     CASE
        WHEN TRIM(b.routepoints_routepointid) = TRIM(a.unassignedroutepoints_routepointid)                                                          THEN 1
        WHEN TRIM(b.routepoints_routepointid) = TRIM(a.routes_routepoints_routepointid)                                                             THEN 0
        ELSE                                                                                                                            NULL
     END                                                                                                                             AS result_flag_unassigned_routepointid                        ,
     a.code                                                                                                                          AS result_code                                                ,
     a.error                                                                                                                         AS result_error

FROM ${database_safe}.${table_safe_tournee_resultat}       a
LEFT JOIN ${database_safe}.${table_safe_tournee_demande}   b
ON TRIM(a.routingid) = TRIM(b.routingid)
        AND
   TRIM(a.producer)  = TRIM(b.producer)                                                                                                                                                                        ;
