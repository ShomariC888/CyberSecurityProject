<h1>File Monitoring Script README </h1>
<p>
  This script provides a solution for monitoring changes to files within a directory. Using PowerShell, 
  it tracks file changes by creating a baseline of file hashes and then continuously monitoring those files for any alterations. 
</p>


<h2>Function Descriptions: </h2>
<ol>
  <li>Prompt()</li>
  <p>This function displays a menu to the user, offering them three options: </p>
  <ul>
    <li>Collect new Baseline?</li>
    <li>Begin monitoring files with saved Baseline?</li>
    <li>Exit</li>
  </ul>
  <br>
  <p>
    The function then waits for the user's input and returns their choice.
  </p>

  <li>Calculate-File-Hash($filepath)</li>
  <p>
    This function takes a file path as its argument and returns the SHA512 hash of that file. It utilizes PowerShell's Get-FileHash cmdlet.
  </p>

  <li>Erase-Baseline-If-Already-Exists()</li>
  <p>
    THis function will remove file (baseline.txt) if it already exists within the directory being monitored. 
    This ensures that when a new baseline is collected, and any old data is deleted.
  </p>
  <li>OptionC()</li>
  
</ol>
