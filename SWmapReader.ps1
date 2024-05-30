#Syndicate Wars Map Reader by Moburma

#VERSION 0.1
#LAST MODIFIED: 30/05/2024

<#
.SYNOPSIS
   This script can read Syndicate Wars Map files (.MAD) and output human readable information 
   on all building Things placed in that level, including their type (if not just a regular building), 3D coordinates and ThingOffset value 
   (needed for creating or customising levels).

.DESCRIPTION    
    Reads Syndicate Wars map files and outputs building definitions as human readable data. Also exports the details to a CSV 
    in current directory.
    

.PARAMETER Filename
   
   The map file to open. E.g. MAP065.MAD


.RELATED LINKS
    
    
#>

Param ($filename)


if ($filename -eq $null){
write-host "Error - No argument provided. Please supply a target map file to read!"
write-host ""
write-host "Example: SWMapReader.ps1 MAP065.MAD"
exit
}


if ((Test-Path -Path $filename -PathType Leaf) -eq 0){
write-host "Error - No file with that name found. Please supply a target map file to read!"
write-host ""
write-host "Example: SWMapReader.ps1 MAP065.MAD"
exit
}

$levfile = Get-Content $filename -Encoding Byte -ReadCount 0

function convert16bitint($Byteone, $Bytetwo) {
   
$converbytes16 = [byte[]]($Byteone,$Bytetwo)
$converted16 =[bitconverter]::ToInt16($converbytes16,0)

return $converted16

}

function convert32bitint($Byteone, $Bytetwo, $Bytethree, $ByteFour) {
   
$converbytes32 = [byte[]]($Byteone,$Bytetwo,$Bytethree,$ByteFour)
$converted32 =[bitconverter]::ToUInt32($converbytes32,0)

return $converted32

}


function identifyBuilding($Type){ #Returns what building type the Thing is based on type

Switch ($type){  


    0{ return 'IML Station Platform'}
    20{ return 'Shuttle Loader/Transport Tube'}
    21{ return 'Bezier Road Segment'}
    24{ return 'Dome'}
    27{ return 'Building'}
    28{ return 'IML Track'}
    32{ return 'Mounted Gun'}
    #33{ return 'Fence'} #state is 33, not type
    37{ return 'Gate'}
    47{ return 'IML Station'}
    61{ return 'Large Rectangular Building'}


}

}


$counter = 0

$fpos = ($levfile.length - 168)

$Fileoutput = @()


DO
{

$counter = $counter +1

#echo $fpos

$Parent =  convert16bitint $levfile[$fpos] $levfile[$fpos+1]
$Next =  convert16bitint $levfile[$fpos+2] $levfile[$fpos+3]
$LinkParent = convert16bitint $levfile[$fpos+4] $levfile[$fpos+5]
$LinkChild =  convert16bitint $levfile[$fpos+6] $levfile[$fpos+7]
$type = $levfile[$fpos+8]
$thingtype = $levfile[$fpos+9]
$state = convert16bitint $levfile[$fpos+10] $levfile[$fpos+11]
$BuildingType = identifyBuilding $type
$Flag =  convert32bitint $levfile[$fpos+12] $levfile[$fpos+13] $levfile[$fpos+14] $levfile[$fpos+15]
$LinkSame = convert16bitint $levfile[$fpos+16] $levfile[$fpos+17]
$LinkSameGroup = convert16bitint $levfile[$fpos+18] $levfile[$fpos+19]
$Radius = convert16bitint $levfile[$fpos+20] $levfile[$fpos+21]
$ThingOffset = convert16bitint $levfile[$fpos+22] $levfile[$fpos+23]
$map_posx = convert32bitint $levfile[$fpos+24] $levfile[$fpos+25] $levfile[$fpos+26] $levfile[$fpos+27]
$map_posy = convert32bitint $levfile[$fpos+28] $levfile[$fpos+29] $levfile[$fpos+30] $levfile[$fpos+31]
$map_posz = convert32bitint $levfile[$fpos+32] $levfile[$fpos+33] $levfile[$fpos+34] $levfile[$fpos+35]
$Frame = convert16bitint $levfile[$fpos+36] $levfile[$fpos+37]
$StartFrame = convert16bitint $levfile[$fpos+38] $levfile[$fpos+39]
$Timer1 = convert16bitint $levfile[$fpos+40] $levfile[$fpos+41]
$StartTimer1 = convert16bitint $levfile[$fpos+42] $levfile[$fpos+43]
$VX = convert32bitint $levfile[$fpos+44] $levfile[$fpos+45] $levfile[$fpos+46] $levfile[$fpos+47]
$VY = convert32bitint $levfile[$fpos+48] $levfile[$fpos+49] $levfile[$fpos+50] $levfile[$fpos+51]
$VZ = convert32bitint $levfile[$fpos+52] $levfile[$fpos+53] $levfile[$fpos+54] $levfile[$fpos+55]
$Speed = convert16bitint $levfile[$fpos+56] $levfile[$fpos+57]
$Health = convert16bitint $levfile[$fpos+58] $levfile[$fpos+59]
$Owner = convert16bitint $levfile[$fpos+60] $levfile[$fpos+61]
$PathOffset = $levfile[$fpos+62]
$SubState = $levfile[$fpos+63]
$PTarget = convert16bitint $levfile[$fpos+66] $levfile[$fpos+67]
$Flag2 = convert32bitint $levfile[$fpos+68] $levfile[$fpos+69] $levfile[$fpos+70] $levfile[$fpos+71]
$GotoThingIndex = convert16bitint $levfile[$fpos+72] $levfile[$fpos+73]
$OldTarget = convert16bitint $levfile[$fpos+74] $levfile[$fpos+75]
$NextThing = convert16bitint $levfile[$fpos+76] $levfile[$fpos+77]
$PrevThing = convert16bitint $levfile[$fpos+78] $levfile[$fpos+79]
$Group = $levfile[$fpos+80]
$EffectiveGroup = $levfile[$fpos+81]
$Object = convert16bitint $levfile[$fpos+82] $levfile[$fpos+83]
$MatrixIndex = convert16bitint $levfile[$fpos+84] $levfile[$fpos+85]
$NumbObjects = $levfile[$fpos+86]
$Angle = $levfile[$fpos+87]
$Token = $levfile[$fpos+88]
$TokenDir = $levfile[$fpos+89]
$OffX = $levfile[$fpos+90]
$OffZ = $levfile[$fpos+91]
$TargetDX = convert16bitint $levfile[$fpos+92] $levfile[$fpos+93]
$TargetDY = convert16bitint $levfile[$fpos+94] $levfile[$fpos+95]
$TargetDZ = convert16bitint $levfile[$fpos+96] $levfile[$fpos+97]
$BuildStartVect = convert16bitint $levfile[$fpos+98] $levfile[$fpos+99]
$BuildNumbVect = convert16bitint $levfile[$fpos+100] $levfile[$fpos+101]
$ZZ_unused_but_pads_to_long_ObjectNo = convert16bitint $levfile[$fpos+102] $levfile[$fpos+103]
$ComHead = convert16bitint $levfile[$fpos+104] $levfile[$fpos+105]
$ComCur = convert16bitint $levfile[$fpos+106] $levfile[$fpos+107]
$Mood = convert16bitint $levfile[$fpos+102] $levfile[$fpos+103]
$RaiseDY1 = convert16bitint $levfile[$fpos+104] $levfile[$fpos+105]
$RaiseDY2 = convert16bitint $levfile[$fpos+106] $levfile[$fpos+107]
$RaiseY1 = convert16bitint $levfile[$fpos+108] $levfile[$fpos+109]
$RaiseY2 = convert16bitint $levfile[$fpos+110] $levfile[$fpos+111]
$MinY1 = convert16bitint $levfile[$fpos+112] $levfile[$fpos+113]
$MinY2 = convert16bitint $levfile[$fpos+114] $levfile[$fpos+115]
$Timer3 = convert16bitint $levfile[$fpos+116] $levfile[$fpos+117]
$Timer4 = convert16bitint $levfile[$fpos+118] $levfile[$fpos+119]
$MaxY1 = convert16bitint $levfile[$fpos+120] $levfile[$fpos+121]
$TNode = convert16bitint $levfile[$fpos+122] $levfile[$fpos+123]
$Cost = convert16bitint $levfile[$fpos+124] $levfile[$fpos+125]
$Shite = convert16bitint $levfile[$fpos+126] $levfile[$fpos+127]
$BHeight = convert32bitint $levfile[$fpos+128] $levfile[$fpos+129] $levfile[$fpos+130] $levfile[$fpos+131]
$Turn = convert16bitint $levfile[$fpos+132] $levfile[$fpos+133]
$short = convert16bitint $levfile[$fpos+134] $levfile[$fpos+135]
$tnode1 = convert16bitint $levfile[$fpos+136] $levfile[$fpos+137]
$tnode2 = convert16bitint $levfile[$fpos+138] $levfile[$fpos+139]
$tnode3 = convert16bitint $levfile[$fpos+140] $levfile[$fpos+141]
$tnode4 = convert16bitint $levfile[$fpos+142] $levfile[$fpos+143]
$player_in_me = $levfile[$fpos+144]
$unkn_4D = $levfile[$fpos+145]
$DrawTurn  = convert32bitint $levfile[$fpos+146] $levfile[$fpos+147] $levfile[$fpos+148] $levfile[$fpos+149]
$tnode_50_1 = convert16bitint $levfile[$fpos+150] $levfile[$fpos+151]
$tnode_50_2 = convert16bitint $levfile[$fpos+152] $levfile[$fpos+153]
$tnode_50_3 = convert16bitint $levfile[$fpos+154] $levfile[$fpos+154]
$tnode_50_4 = convert16bitint $levfile[$fpos+156] $levfile[$fpos+157]
$pad1 = convert32bitint $levfile[$fpos+158] $levfile[$fpos+159] $levfile[$fpos+160] $levfile[$fpos+161]
$pad2 = convert32bitint $levfile[$fpos+162] $levfile[$fpos+163] $levfile[$fpos+164] $levfile[$fpos+165]
$pad3 = convert16bitint $levfile[$fpos+166] $levfile[$fpos+167]

#output toarray to output CSV file 

$CharacterEntry = New-Object PSObject
$CharacterEntry | Add-Member -type NoteProperty -Name 'Character No.' -Value $counter
$CharacterEntry | Add-Member -type NoteProperty -Name 'Parent' -Value $Parent
$CharacterEntry | Add-Member -type NoteProperty -Name 'Next' -Value $Next
$CharacterEntry | Add-Member -type NoteProperty -Name 'LinkParent' -Value $LinkParent
$CharacterEntry | Add-Member -type NoteProperty -Name 'Link Child' -Value $LinkChild
$CharacterEntry | Add-Member -type NoteProperty -Name 'Type' -Value $type
$CharacterEntry | Add-Member -type NoteProperty -Name 'Thing Type' -Value $thingtype
$CharacterEntry | Add-Member -type NoteProperty -Name 'Building Type' -Value $Buildingtype
$CharacterEntry | Add-Member -type NoteProperty -Name 'State' -Value $state
$CharacterEntry | Add-Member -type NoteProperty -Name 'Flag' -Value $flag
$CharacterEntry | Add-Member -type NoteProperty -Name 'LinkSame' -Value $LinkSame
$CharacterEntry | Add-Member -type NoteProperty -Name 'LinkSame Group' -Value $LinkSameGroup
$CharacterEntry | Add-Member -type NoteProperty -Name 'Radius' -Value $Radius
$CharacterEntry | Add-Member -type NoteProperty -Name 'Thing Offset' -Value $ThingOffset
$CharacterEntry | Add-Member -type NoteProperty -Name 'X Position' -Value $map_posx
$CharacterEntry | Add-Member -type NoteProperty -Name 'Y Position' -Value $map_posy
$CharacterEntry | Add-Member -type NoteProperty -Name 'Z Position' -Value $map_posz
$CharacterEntry | Add-Member -type NoteProperty -Name 'Frame' -Value $Frame
$CharacterEntry | Add-Member -type NoteProperty -Name 'StartFrame' -Value $StartFrame
$CharacterEntry | Add-Member -type NoteProperty -Name 'Timer1' -Value $Timer1
$CharacterEntry | Add-Member -type NoteProperty -Name 'StartTimer1' -Value $StartTimer1
$CharacterEntry | Add-Member -type NoteProperty -Name 'VX' -Value $VX
$CharacterEntry | Add-Member -type NoteProperty -Name 'VY' -Value $VY
$CharacterEntry | Add-Member -type NoteProperty -Name 'VZ' -Value $VZ
$CharacterEntry | Add-Member -type NoteProperty -Name 'Speed' -Value $Speed
$CharacterEntry | Add-Member -type NoteProperty -Name 'Health' -Value $Health
$CharacterEntry | Add-Member -type NoteProperty -Name 'Owner' -Value $Owner
$CharacterEntry | Add-Member -type NoteProperty -Name 'PathOffSet' -Value $PathOffSet
$CharacterEntry | Add-Member -type NoteProperty -Name 'SubState' -Value $Substate
$CharacterEntry | Add-Member -type NoteProperty -Name 'PTarget' -Value $PTarget
$CharacterEntry | Add-Member -type NoteProperty -Name 'Flag2' -Value $Flag2
$CharacterEntry | Add-Member -type NoteProperty -Name 'GotoThingIndex' -Value $Gotothingindex
$CharacterEntry | Add-Member -type NoteProperty -Name 'OldTarget' -Value $OldTarget
$CharacterEntry | Add-Member -type NoteProperty -Name 'NextThing' -Value $NextThing
$CharacterEntry | Add-Member -type NoteProperty -Name 'PrevThing' -Value $PrevThing
$CharacterEntry | Add-Member -type NoteProperty -Name 'Group' -Value $Group
$CharacterEntry | Add-Member -type NoteProperty -Name 'EffectiveGroup' -Value $EffectiveGroup
$CharacterEntry | Add-Member -type NoteProperty -Name 'Object' -Value $Object
$CharacterEntry | Add-Member -type NoteProperty -Name 'MatrixIndex' -Value $MatrixIndex
$CharacterEntry | Add-Member -type NoteProperty -Name 'NumbObjects' -Value $NumbObjects
$CharacterEntry | Add-Member -type NoteProperty -Name 'Angle' -Value $Angle
$CharacterEntry | Add-Member -type NoteProperty -Name 'Token' -Value $Token
$CharacterEntry | Add-Member -type NoteProperty -Name 'TokenDir' -Value $TokenDir
$CharacterEntry | Add-Member -type NoteProperty -Name 'OffX' -Value $OffX
$CharacterEntry | Add-Member -type NoteProperty -Name 'OffZ' -Value $OffZ
$CharacterEntry | Add-Member -type NoteProperty -Name 'TargetDX' -Value $TargetDX
$CharacterEntry | Add-Member -type NoteProperty -Name 'TargetDY' -Value $TargetDY
$CharacterEntry | Add-Member -type NoteProperty -Name 'TargetDZ' -Value $TargetDZ
$CharacterEntry | Add-Member -type NoteProperty -Name 'BuildStartVect' -Value $BuildStartVect
$CharacterEntry | Add-Member -type NoteProperty -Name 'BuildNumbVect' -Value $BuildNumbVect
$CharacterEntry | Add-Member -type NoteProperty -Name 'ZZ_unused_but_pads_to_long_ObjectNo' -Value $ZZ_unused_but_pads_to_long_ObjectNo
$CharacterEntry | Add-Member -type NoteProperty -Name 'ComHead' -Value $ComHead
$CharacterEntry | Add-Member -type NoteProperty -Name 'ComCur' -Value $ComCur
$CharacterEntry | Add-Member -type NoteProperty -Name 'Mood' -Value $Mood
$CharacterEntry | Add-Member -type NoteProperty -Name 'RaiseDY1' -Value $RaiseDY1
$CharacterEntry | Add-Member -type NoteProperty -Name 'RaiseDY2' -Value $RaiseDY2
$CharacterEntry | Add-Member -type NoteProperty -Name 'RaiseY1' -Value $RaiseY1
$CharacterEntry | Add-Member -type NoteProperty -Name 'RaiseY2' -Value $RaiseY2
$CharacterEntry | Add-Member -type NoteProperty -Name 'MinY1' -Value $MinY1
$CharacterEntry | Add-Member -type NoteProperty -Name 'MinY2' -Value $MinY2
$CharacterEntry | Add-Member -type NoteProperty -Name 'Timer3' -Value $Timer3
$CharacterEntry | Add-Member -type NoteProperty -Name 'Timer4' -Value $Timer4
$CharacterEntry | Add-Member -type NoteProperty -Name 'MaxY1' -Value $MaxY1
$CharacterEntry | Add-Member -type NoteProperty -Name 'TNode' -Value $TNode
$CharacterEntry | Add-Member -type NoteProperty -Name 'Cost' -Value $Cost
$CharacterEntry | Add-Member -type NoteProperty -Name 'Shite' -Value $Shite
$CharacterEntry | Add-Member -type NoteProperty -Name 'BHeight' -Value $BHeight
$CharacterEntry | Add-Member -type NoteProperty -Name 'Turn' -Value $Turn
$CharacterEntry | Add-Member -type NoteProperty -Name 'short' -Value $short
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode1' -Value $tnode1
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode2' -Value $tnode2
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode3' -Value $tnode3
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode4' -Value $tnode4
$CharacterEntry | Add-Member -type NoteProperty -Name 'player_in_me' -Value $player_in_me
$CharacterEntry | Add-Member -type NoteProperty -Name 'unkn_4D' -Value $unkn_4D
$CharacterEntry | Add-Member -type NoteProperty -Name 'DrawTurn ' -Value $DrawTurn 
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode_50_1' -Value $tnode_50_1
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode_50_2' -Value $tnode_50_2
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode_50_3' -Value $tnode_50_3
$CharacterEntry | Add-Member -type NoteProperty -Name 'tnode_50_4' -Value $tnode_50_4
$CharacterEntry | Add-Member -type NoteProperty -Name 'pad1' -Value $pad1
$CharacterEntry | Add-Member -type NoteProperty -Name 'pad2' -Value $pad2
$CharacterEntry | Add-Member -type NoteProperty -Name 'pad3' -Value $pad3


$Fileoutput += $characterentry

$thingnum = convert16bitint $levfile[$fpos-2] $levfile[$fpos-1]
#write-host $thingnum

$fpos = $fpos - 168
}
UNTIL ($counter -eq $thingNum)

#Output to CSV
$csvname = [io.path]::GetFileName("$filename")

$fileext = $csvname+"mapThings.csv"
write-host "$thingnum Things exported"
write-host "Exporting to $fileext"

$Fileoutput | export-csv -NoTypeInformation $fileext




