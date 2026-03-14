#!/bin/bash

steamcmd_dir="$HOME/steamcmd"
install_dir="$HOME/dontstarvetogether_dedicated_server"
cluster_name="MyDediServer"
dontstarve_dir="$HOME/Documents/Klei/DoNotStarveTogether"

# cluster_mods="$dontstarve_dir/$cluster_name/mods"
# server_mods="$install_dir/dontstarve_dedicated_server_nullrenderer.app/Contents/Resources/mods"

function fail()
{
	echo Error: "$@" >&2
	exit 1
}

function check_for_file()
{
	if [ ! -e "$1" ]; then
		fail "Missing file: $1"
	fi
}

cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"

check_for_file "steamcmd.sh"
check_for_file "$dontstarve_dir/$cluster_name/cluster.ini"
check_for_file "$dontstarve_dir/$cluster_name/cluster_token.txt"
check_for_file "$dontstarve_dir/$cluster_name/Master/server.ini"
check_for_file "$dontstarve_dir/$cluster_name/Caves/server.ini"

./steamcmd.sh +force_install_dir "$install_dir" +login anonymous +quit

# if [ -d "$cluster_mods" ]; then
# 	echo "Copying mods from cluster to server directory..."
# 	# mkdir -p "$server_mods" || fail "Cannot create server mods directory"
# 	cp -R "$cluster_mods/." "$server_mods/" || fail "Failed to copy mods"
# else
# 	echo "Error: cluster mods directory not found: $cluster_mods" >&2
# 	exit 1
# fi

check_for_file "$install_dir/dontstarve_dedicated_server_nullrenderer.app/Contents/MacOS/"

cd "$install_dir/dontstarve_dedicated_server_nullrenderer.app/Contents/Resources/" || fail

run_shared=(../MacOS/dontstarve_dedicated_server_nullrenderer)
run_shared+=(-console)
run_shared+=(-cluster "$cluster_name")
run_shared+=(-monitor_parent_process $$)

"${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /' &
"${run_shared[@]}" -shard Master | sed 's/^/Master: /'
