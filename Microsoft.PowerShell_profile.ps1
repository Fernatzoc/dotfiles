if (Get-Command starship -ErrorAction SilentlyContinue) {
	Invoke-Expression (& starship init powershell)
}

if (Get-Module -ListAvailable -Name Terminal-Icons) {
	Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}

if (Get-Command fzf -ErrorAction SilentlyContinue) {
	Set-Alias -Name ff -Value fzf -ErrorAction SilentlyContinue

	if (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) {
		Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -BriefDescription 'FzfHistory' -ScriptBlock {
			$selected = Get-History |
				Sort-Object Id -Descending |
				Select-Object -ExpandProperty CommandLine |
				fzf --height 40% --layout=reverse

			if ($selected) {
				[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
				[Microsoft.PowerShell.PSConsoleReadLine]::Insert($selected)
			}
		}

		Set-PSReadLineKeyHandler -Chord 'Ctrl+t' -BriefDescription 'FzfFile' -ScriptBlock {
			$selected = Get-ChildItem -File -Recurse -ErrorAction SilentlyContinue |
				ForEach-Object FullName |
				fzf --height 40% --layout=reverse

			if ($selected) {
				[Microsoft.PowerShell.PSConsoleReadLine]::Insert($selected)
			}
		}
	}
}