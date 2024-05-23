for version in 23.09
do

	pushd "$installroot/modules/SystemPartition/LUMI/$version/partition"
	create_link "$installroot/LUMI-SoftwareStack/modules/LUMIpartition/21.01.lua" D.lua
	popd

	mkdir -p "$installroot/modules/Infrastructure/LUMI/$version/partition/D/EasyBuild-production"
	pushd "$installroot/modules/Infrastructure/LUMI/$version/partition/D/EasyBuild-production"
	create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
	cd ..
	mkdir -p EasyBuild-user
	cd EasyBuild-user
	create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-config/21.01.lua" LUMI.lua
	cd ..
	mkdir -p EasyBuild-unlock
	cd EasyBuild-unlock
	create_link "$installroot/LUMI-SoftwareStack/modules/EasyBuild-unlock/21.01.lua" LUMI.lua
	cd ..
	create_link "$installroot/modules/easybuild/LUMI/$version/partition/common/EasyBuild" EasyBuild
	popd

done
