dbnames=`mongo --quiet --eval "db.getMongo().getDBNames().join(' ')"`

echo "all dbs:${dbnames}"
for dbname in $dbnames
do
	echo $dbname
	if [ "$dbname" = "admin" ] || [ "$dbname" = "config" ] || [ "$dbname" = "local" ];then
		echo "${dbname} need continue"
		continue
	fi
	mkdir $dbname
	collections=`mongo --quiet --eval "new Mongo().getDB('${dbname}').getCollectionNames().join(' ')"`
	
	for collection in $collections
	do
		echo "${dbname} has collection: ${collection}"
		mkdir "./${dbname}/$collection"
		docCount=`mongo --quiet --eval "new Mongo().getDB('${dbname}').${collection}.countDocuments({})"`
		echo "total doucment count:${docCount}"
		
		#切成4等分
		windowSize=$(($docCount/4))
		skipCount=0
		#切4等分的話for迴圈只需要執行3次
		for i in {0..2}
		do
			dumpName="${dbname}/${collection}/${dbname}_${collection}_$(($i+1))_4.archive"
			#拿到這次要備份的start跟end _id
			from=`mongo --quiet --eval "new Mongo().getDB('${dbname}').${collection}.find().sort({_id:1}).skip(${skipCount}).limit(1).toArray()[0]._id.toString().substring(10,34)"`
			to=`mongo --quiet --eval "new Mongo().getDB('${dbname}').${collection}.find().sort({_id:1}).skip($(($skipCount+$windowSize-1))).limit(1).toArray()[0]._id.toString().substring(10,34)"` 
	
			result=$(mongodump -d "${dbname}" -c "${collection}" -q "{\"_id\":{\"\$gte\":{\"\$oid\":\"${from}\"},\"\$lte\":{\"\$oid\":\"${to}\"}}}" --archive="./${dumpName}")
			echo "####r:${result}"
			echo "@@@query result is: ${from} ${to}, status code: ${PIPESTATUS[@]}"
			skipCount=$(($skipCount+$windowSize))
		done
		
		dumpName="${dbname}/${collection}/${dbname}_${collection}_4_4.archive"
		from=`mongo --quiet --eval "new Mongo().getDB('${dbname}').${collection}.find().sort({_id:1}).skip(${skipCount}).limit(1).toArray()[0]._id.toString().substring(10,34)"`
		#最後一項可以用sort(-1)來找會比較快
		to=`mongo --quiet --eval "new Mongo().getDB('${dbname}').${collection}.find().sort({_id:-1}).limit(1).toArray()[0]._id.toString().substring(10,34)"` 
		result=$(mongodump -d "${dbname}" -c "${collection}" -q "{\"_id\":{\"\$gte\":{\"\$oid\":\"${from}\"},\"\$lte\":{\"\$oid\":\"${to}\"}}}" --archive="./${dumpName}")
		echo "query result is: ${from} ${to}, status code: ${PIPESTATUS[@]}"
	done
done

now="$(date +'%Y%m%d %H:%M:%S')"
echo "now date:${now}"



sleep 100
