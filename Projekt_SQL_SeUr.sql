ELECT *
FROM healthcare_provider hp 
WHERE place_id IS NULL
	OR provider_id IS NULL
	OR name IS NULL
	OR street_name IS NULL;
