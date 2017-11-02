# store current platforms in variable
.packages[0].platforms as $currentPlatforms
# assign
| .packages[0].platforms = ([$newPlatform, $currentPlatforms] | flatten)
