function hab_accept {
  hab license accept
}

choco install habitat --version ${hab_version} -y
choco install git -y
choco install googlechrome -y
choco install vscode -y
choco install chef-workstation --version ${chef_workstation_version} -y
hab_accept
