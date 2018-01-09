[ .packages[].platforms[] | select(.name == $name and .version == $version) | .toolsDependencies[] | select(.name != "arduinoOTA") ]
