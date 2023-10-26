
#Improve upon this code by:
#Let user pick which folder to monitor the files
#recursive file monitoring to monitor all files in a folder structure 
#Error checking: if user wants to monitor files and there is no baseline, add flow control to redirect user back to create a baseline
#how to make it e-mail you with powershell or use twillio api to send you a text message
#Prompt user to monitor another directory once they choose to exit.
###dd
Function Prompt(){

    Write-Host ""
    Write-Host "What would you like to do?"
    Write-Host "A) Collect new Baseline?"
    Write-Host "B) Begin monitoring files with saved Baseline?"
    Write-Host "C) Exit"
    Write-Host ""

    return Read-Host -Prompt "Please enter 'A' or 'B' or 'C'"
}

$response = Prompt

#Calculate the hash file
Function Calculate-File-Hash($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}


Function Erase-Baseline-If-Already-Exists(){
    $baselineExists = Test-Path -Path $desiredDirectoryPath\baseline.txt
    if ($baselineExists){
        #delete it
        Remove-Item -Path $desiredDirectoryPath\baseline.txt
    }#else{
       # Get-ChildItem -Path $directoryPath -File | ba
    #}

}

if($response -eq "C".ToUpper()){
        Write-Host "Exiting...."
        break
}

$desiredDirectoryPath = Read-Host -Prompt "Please enter the directory path you'd like to monitor: "

Function OptionC(){
    if(-not (Test-Path $desiredDirectoryPath)){
        Write-Host "Invalid directory path. Exiting..."
        return
    }
}
$run = OptionC

do{
    
    #logic to prompt user to select option A if baseline.txt file does not exist in directory.
    while($response -eq "B".ToUpper() -and -not(Test-Path $desiredDirectoryPath\baseline.txt)){
        Write-Host "Baseline doesn't exist. Please select option 'A' to create one."
        $response = Prompt
    }
    
    #logic to prompt user to select option B if baseline.txt file already exists in directory.
    while($response -eq "A".ToUpper() -and (Test-Path $desiredDirectoryPath\baseline.txt)){
        Write-Host "Baseline exists. Please select option 'B' to start monitoring."
        $response = Prompt
    }
   #while($response = OptionC){
    #   Write-Host "'C' was selected, returning to Prompt."
   #    $response = Prompt
   #}
    
    if ($response -eq "A".ToUpper()){
        #Delete baseline.txt if it already exists
        Erase-Baseline-If-Already-Exists $desiredDirectoryPath
    
        #Calculate hash from the target files and store in baseline.txt
   

        #Collect all files in the target folder
        $files = Get-ChildItem -Path $desiredDirectoryPath 
    

        #For file, calculate the hash, and write to baseline .txt
        foreach ($f in $files){
            $hash = Calculate-File-Hash $f.FullName
            "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath $desiredDirectoryPath\baseline.txt -Append
        }
        $response = Prompt
    }

    elseif($response -eq "B".ToUpper()){
    
        $fileHashDictionary = @{} #Clear out dictionary

        #Load file|hash from baseline.txt and store them in a dictionary
        $filePathsAndHashes = Get-Content -Path $desiredDirectoryPath\baseline.txt #Collect paths and hashes
    
        #Add each path and hash to the dictionary
        foreach($f in $filePathsAndHashes){
            $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
            }

    
    

        #Begin(continuously) monitoring files with saved Baseline
        while($true){
            Start-Sleep -Seconds 1
        
            $files = Get-ChildItem -Path $desiredDirectoryPath #Get all of our files and store
    
    
        #For file, calculate the hash, and write to baseline .txt
            foreach ($f in $files){
                $hash = Calculate-File-Hash $f.FullName
              # "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

              #Notify that a new file has been created
              if($fileHashDictionary[$hash.Path] -eq $null){
                #Someone created a file that doesn't exist in our dictionary
                Write-Host "$($hash.Path) has been created!" -foreGroundColor Green

              }else{
                  #Notify if a new file has been changed
                  if($fileHashDictionary[$hash.Path] -eq $hash.Hash){
                  #The file has not changed
              
                    
                  }
                  else {
                  #File file has been compromised, notify the user
                    Write-Host "$($hash.Path) has changed!!!" -foreGroundColor Red
                  }
              }

         
            } 

        
            foreach ($key in $fileHashDictionary.Keys){
               $baselineFileStillExists = Test-Path -Path $key
               if (-Not $baselineFileStillExists){
                    #One of the baseline files must have been deleted, notify the user
                    Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed
               }
              }
        
        }
    
    
    }
   
    
}while($response -ne "exit")
    
    


