for dbname in $(ls)
do
	if [ -d $dbname ];then
	
		echo "${dbname} is folder"
	
		for collection in $(ls $dbname)
		do
			echo "collection:${collection}"
			if [ -d "${dbname}${collection}" ];then
					#dir是放archive的資料夾路徑
					dir="${dbname}${collection}"
					for archiveFile in $(ls $dir)
					do
						fullFileName="${dir}${archiveFile}"
						echo "file:${fullFileName}"
						mongoRestore --host=localhost:27018 --archive="${fullFileName}"
					done
			fi
		done
		
	else
		continue
	fi
done

echo 'eee'
sleep 100