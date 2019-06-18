# Log cleanup delete

# Log Cleanup Policy: Delete

	- log.retention.hours:
		- number of hours to keep data for (default is 168 hours - one week)
		- Higher number means more disk space
		- Lower number means that less data is retained (if your consumers are down for too long, they can miss data)

	- log.retention.bytes
		- Max size in Bytes for each partition (defaults is -1 - infinite)
		- Useful to keep the size of a log under a threshold


	- Old segment will be deleted based on time or space rules -------------------->>>>>>>>>> new data is written to the active segment
	- Use cases - two common pair of options:
		- One week of retention:
			- log.retention.hours=168 and log.retention.bytes=-1
		- Infinite time retention bounded by 500MB:
			- log.retention.hours=17520 and log.retention.bytes=524288000