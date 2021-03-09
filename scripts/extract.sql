SELECT
CAST(lr.testdate AS DATE) testdate
,lr.testtype
,p.lga lga_old
,p.metrorural metrorural_old
,p.addressline1
,p.addressline2
,p.fullcleanaddress
,p.streetname
,p.suburb
,p.state
,p.postcode
,p.rawpostcode
,p.longitude
,p.latitude
FROM
covid19labresults.LabResults lr
INNER JOIN covid19persons.Persons p
ON lr.recordid = p.recordid
WHERE
p.latitude IS NOT NULL
AND p.longitude IS NOT NULL