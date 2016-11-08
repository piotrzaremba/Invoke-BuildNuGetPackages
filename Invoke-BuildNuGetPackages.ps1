function Invoke-BuildNugetPackages
{
    $cwd = Get-Location

	$files = get-childitem .
    $files = $files | where {$_.extension -eq '.nuspec'} 
	
    foreach($file in $files)
    {
		$nuspecPath = $cwd.Path + '\' + $file.Name
		
        if(Test-Path $nuspecPath)
        {
            $xml = [xml](Get-Content $nuspecPath)

            $path = $cwd.Path + '\local\package\' + $file.Name + '.' + $xml.package.metadata.version
            if(!(test-path $path))
            {
                New-Item -ItemType Directory -Force -Path $path
            }

            Set-Location $path

            &  'C:\dev\NugetPackageExplorer\nuget.exe' 'pack' $nuspecPath '-properties' 'Configuration=Release' '-IncludeReferencedProjects';
        }
		
		Set-Location $cwd.Path
    }
}