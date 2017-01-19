

$externalJob = 
{
	$internalJob =
	{
		Write-Host "Internal Job finito";
	}

	Start-Job -ScriptBlock $internalJob;
	Write-Host "External Job finito";
}

Start-Job -ScriptBlock $externalJob

Get-Job | Wait-Job
Get-Job | Receive-Job