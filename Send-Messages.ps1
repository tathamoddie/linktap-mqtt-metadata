[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    $MqttHost,

    [Int]
    $MqttPort = 1883,

    [Parameter(Mandatory = $true)]
    $MqttUsername,
    
    [Parameter(Mandatory = $true)]
    [SecureString] $MqttPassword
)

Get-ChildItem messages/ |
    Sort-Object -Property Name |
    ForEach-Object {
        $message = ConvertFrom-Json (Get-Content $_ -Delimiter `0)
        $topic = $message.topic
        $data = $message.data | ConvertTo-Json -Compress

        Write-Host $topic
        Write-Host $data

        $data | . mosquitto_pub -h "$MqttHost" -p "$MqttPort" -u "$MqttUsername" -P "$(ConvertFrom-SecureString $MqttPassword -AsPlainText)" -t "$topic" -l
    }
