Program solver;
// {$MODE DELPHI}
uses 
    crt,sysUtils,DateUtils;

type 
    inputMatrix = array[1..5, 1..5] of integer;
    StrMatrix = array[1..5, 1..5] of String;
    inputArr = array[1..5] of integer;
    inputStr = array[1..5] of String;
    boolMatrix  = array[1..5,1..5] of boolean;
    hashArr     = array[1..5] of boolean;

var
    row,col          : inputArr;
    matrix                          : inputMatrix;
    fileIn                          : Text;
    fileName,txtTemp,phrase         : String;
    tempArr,rowTemp,colTemp         : inputStr;
    i,counter,j,Y,X                 : integer;
    matrixStr                       : StrMatrix;
    maskMatrix                      : boolMatrix;
    FromTime, ToTime                : TDateTime;
    DiffMinutes                     : double;
         


// Load Procedure or Functions
function blankHash() : hashArr;
var
    tempHashArr : hashArr;
    iBlank      : integer;
begin
    for iBlank:=1 to 5 do 
        begin
            tempHashArr[iBlank] := false;
        end;

    blankHash := tempHashArr;
end;

function lastOne(hash : hashArr):boolean;
var
    tempSum : integer;
begin
    for i := 0 to 5 do
        begin
            if(hash[i] = false) then inc(tempSum);
        end;

    if(tempSum = 1) then lastOne := true
    else lastOne := false;
end;

function isBlankHash(hash : hashArr):boolean;
var
    temp : boolean;
begin
    temp:= true;
    for i := 0 to 5 do
        begin
            if(hash[i] = true) then temp := false
        end;
    isBlankHash := temp;
end;

function hashSum(arr : hashArr; numArray : inputArr) : integer;
var 
    iHash,tempSum : integer;
begin
    tempSum := 0;
    for iHash := 1 to 5 do
    begin
        if(arr[iHash] = true) then
        begin
            tempSum := numArray[iHash] + tempSum;
        end;
    end;
    hashSum := tempSum;
end; 

function selectNewHighest(numArray : inputArr; selectedBase : hashArr):hashArr;
var 
    newHash : hashArr;
    newMax,maxIndex  : integer;
    isSelected : boolean;
begin
    isSelected := false;

    // write('Selected Base : ');
    // for i := 1 to 5 do
    //     begin
    //         write(selectedBase[i]);
    //         write(' ');
    //     end;
    write();

    // From here we already have 1 selected maximum number and the hash array
    newHash := blankHash();
    if(isBlankHash(selectedBase)) then
    begin
        newMax := numArray[1];
        maxIndex := 1;
    end
    else
    begin
        newMax := 0;
        while((i<=5) and (not isSelected)) do
           begin
               if(selectedBase[i] = false) then
               begin
                   maxIndex := i;
                   newMax := numArray[i];
                   isSelected := true;
               end;
               inc(i);
           end; 
    end;

    if(lastOne(selectedBase)) then
    begin
        // Don't look for the highest;
    end
    else
    begin
        for i := 1 to 5 do 
        begin
            if((numArray[i] > newMax) and (selectedBase[i] = false)) then
                begin
                    newMax := numArray[i];
                    maxIndex := i;
                end;
        end;
    end;

    newHash[maxIndex] := true;
    selectNewHighest := newHash;
end;

procedure loadFile();   
begin
    phrase := '';
    counter := 1;
    fileName := 'satu.txt';
    Assign(fileIn,fileName);
    Reset(fileIn);

    repeat
        txtTemp := '';
        readln(fileIn, phrase);

        if ( (phrase[length(phrase)+1] <> ' ') OR (counter > 6)) then
            begin
                phrase := concat(phrase,' ');
            end; 
       
        j := 1;
        for i:=1 to length(phrase) do 
            begin
                if(phrase[i] = ' ') then
                begin
                    tempArr[j] := txtTemp;
                    txtTemp := '';
                    inc(j);
                end

                else
                begin
                    txtTemp := concat(txtTemp, phrase[i]);     
                end;
                    
            end;


        // Bila counter < 6 maka akan input ke matrix utama 
        if(counter < 6 ) then 
            begin
                for i:=1 to 5 do
                    begin
                        matrixStr[counter][i] := tempArr[i];
                    end;
            end;

        // Bila counter = 7 Maka dia akan set rowTemp
        if(counter = 6 ) then 
            begin
                rowTemp := tempArr;
            end;

        //Bila counter = 7 maka dia akan set colTemp
        if(counter =  7 ) then 
            begin
                colTemp := tempArr;
            end;
        
        // Increment Counter
        inc(counter);
    until EoF(fileIn);
    close(fileIn);
end;

procedure createNumberMatrix();
begin
    //Convert matrix
    for i:=1 to 5 do
    begin
        for j:=1 to 5 do 
        begin
            matrix[i][j] := StrToInt(matrixStr[i][j]);
        end;
    end;

    //Convert Row and Column
    for i:=1 to 5 do
    begin
        row[i] := StrToInt(rowTemp[i]);
        col[i] := StrToInt(colTemp[i]);
    end;

    //Create mask matrix
    for i:=1 to 5 do
    begin
        for j:=1 to 5 do 
        begin
            maskMatrix[i][j] := false;
        end;
    end;
end;

procedure printMatrix(tempX,tempY : integer);
var 
    base : integer;
begin
    base := tempX;
    //Print Matrix and Row / Col Sum
       for i:=1 to 5 do 
        begin
            tempX := base;
            for j:= 1 to 5 do 
            begin
                GotoXY(tempX,tempY);
                write('  ');
                GotoXY(tempX,tempY);
                write(matrix[i][j]);
                
                tempX := tempX + 3;
            end;
            GotoXY(tempX,tempY);
            TextBackground(13);
            write('  ');
            GotoXY(tempX,tempY);
            write(row[i]);
            TextBackground(black);
            tempY := tempY + 1;
        end;

        // Print Column Sum
        tempX := base;
        for i := 1 to 5 do
            begin
                TextBackground(13);
                GotoXY(tempX,tempY);
                write('  ');
                GotoXY(tempX,tempY);
                write(col[i]);
                tempX := tempX + 3;
                TextBackground(black);
            end;
        tempY := tempY + 2;
        Y := TempY;
end;

procedure printAnswerMatrix(TempX, TempY : integer);
var 
    base : integer;
begin
    base := tempX;
    //Print Matrix and Row / Col Sum
       for i:=1 to 5 do 
        begin
            tempX := base;
            for j:= 1 to 5 do 
            begin
                if(maskMatrix[i][j] = true) then
                begin
                    TextBackground(12);
                end;
                GotoXY(tempX,TempY);
                write('  ');
                GotoXY(tempX,TempY);
                write(matrix[i][j]);
                tempX := tempX + 3;
                TextBackground(black);
            end;
            GotoXY(tempX,TempY);
            TextBackground(13);
            write('  ');
            GotoXY(tempX,TempY);
            write(row[i]);
            TextBackground(black);
            TempY := TempY + 1;
        end;

        // Print Column Sum
        tempX := base;
        for i := 1 to 5 do
            begin
                TextBackground(13);
                GotoXY(tempX,TempY);
                write('  ');
                GotoXY(tempX,TempY);
                write(col[i]);
                tempX := tempX + 3;
                TextBackground(black);
            end;
        TempY := TempY + 2;
end;

procedure printSolution(inputArr : inputMatrix);
begin
    clrscr();
    GotoXY(10,10);
    Write('10,10');
    GotoXY(70,20);
    Write('70,20');
    GotoXY(1,22);
end;

procedure printColor();
begin
    for i := 1 to 15 do
    begin
        textBackground(i);
        GotoXY(i+2,2);
        write(' ');
        GotoXY(i+2,2);
        write(i);
    end;
    writeln();
end;

procedure printMaskMatrix();
begin
    for i:=1 to 5 do 
        begin
            for j:= 1 to 5 do 
            begin
                if(maskMatrix[i][j] = true) then
                begin
                    write(1);
                end
                else
                begin
                    write(0);
                end;
                
                write(' ');
            end;
            writeln();
        end;
end;

function hashFilled(hash : hashArr):boolean;
var
    temp : boolean;
    iFilled : integer;
begin
    temp:= true;
    for iFilled := 1 to 5 do
        begin
            if(hash[iFilled] = false) then
            begin
                 temp := false
            end;
        end;
    hashFilled := temp;
end;

procedure printArray(arr : inputArr; TempX,TempY : integer);
begin
    for i := 1 to 5 do
        begin
            GotoXY(TempX, TempY);
            write('  ');
            GotoXY(TempX, TempY);
            write(arr[i]);
            TempX := TempX + 3;
        end;
end;

procedure printHashArray(arr : hashArr; TempX,TempY : integer);
begin
    for i := 1 to 5 do
        begin
            GotoXY(TempX, TempY);
            write('  ');
            GotoXY(TempX, TempY);
            if(arr[i] = true) then
            begin
                 write('1');
            end
                else write('0');
            TempX := TempX + 3;
        end;
end;

procedure printHashNumberArray(arr : hashArr; TempX,TempY,TargetRow : integer);
begin
    for i := 1 to 5 do
        begin
            GotoXY(TempX, TempY);
            write('  ');
            GotoXY(TempX, TempY);
            if(arr[i] = true) then
            begin
                 write(matrix[targetRow][i]);
            end
                else write('0');
            TempX := TempX + 3;
        end;
end;



procedure printSelected(arr : hashArr; targetRow,TempX,TempY : integer);
begin
    for i := 1 to 5 do
        begin
            if(arr[i] = true) then
            begin
                GotoXY(TempX,TempY);
                writeln(matrix[targetRow][i]);
            end;
        end;
end;

procedure preLoad();
begin
    matrix[1][1] := 7;
    matrix[1][2] := 5;
    matrix[1][3] := 3;
    matrix[1][4] := 5;
    matrix[1][5] := 6;

    matrix[2][1] := 7;
    matrix[2][2] := 5;
    matrix[2][3] := 4;
    matrix[2][4] := 7;
    matrix[2][5] := 5;

    matrix[3][1] := 8;
    matrix[3][2] := 3;
    matrix[3][3] := 2;
    matrix[3][4] := 9;
    matrix[3][5] := 2;

    matrix[4][1] := 3;
    matrix[4][2] := 5;
    matrix[4][3] := 5;
    matrix[4][4] := 4;
    matrix[4][5] := 1;

    matrix[5][1] := 3;
    matrix[5][2] := 7;
    matrix[5][3] := 3;
    matrix[5][4] := 1;
    matrix[5][5] := 5;    

    row[1] := 5;
    row[2] := 19;
    row[3] := 13;
    row[4] := 13;
    row[5] := 14;

    col[1] := 21;
    col[2] := 19;
    col[3] := 6;
    col[4] := 12;
    col[5] := 6;
end;

procedure getPossibleRow(targetRow : integer);
var
    ansHash, selectedHash, selectedBase, otherBig, tempSelected               : hashArr;
    isRowSolved                                                               : boolean;  
    TempY,TempX : integer;
begin
    TempY := Y;
    TempX := X;
    if(targetRow>1) then
    begin
        TempX := TempX*targetRow+(10*targetRow-2)-8;
    end;
    isRowSolved := false;
    ansHash := blankHash();
    selectedBase := ansHash;

    GotoXY(TempX,TempY);
    write('Solving Baris - ');
    TextColor(14);
    write(targetRow);
    TextColor(white);
    TempY := TempY + 2;

    GotoXY(TempX,TempY);
    write('Row Value : ');
    TempY := TempY+1;
    printArray(matrix[targetRow],tempX,tempY);
    TempY := TempY+2;

    while((isRowSolved = false) and (hashFilled(selectedBase) = false)) do
    begin
        // Select a new base and don't reselect ever selected base
        ansHash := selectNewHighest(matrix[targetRow],selectedBase);
    
        //Update Selected base
        for i := 1 to 5 do
            begin
                if(ansHash[i] = true) then 
                begin
                    selectedBase[i] := true;
                end;
            end;
        
        if(hashSum(ansHash,matrix[targetRow]) = row[targetRow]) then
        begin
            isRowSolved := true;
        end;

        // Show Total nilai

        // Show solved atau enggak

        if(isRowSolved = true) then
        begin
            maskMatrix[targetRow] := ansHash;
        end

        // if row is not solved try to add base number with other biggest number
        // Here will try every possibilities
        else
        begin
            // Update selected hash to the latest answer so it wont reselect
            

            selectedHash := ansHash;
            tempSelected := ansHash;
            while((hashFilled(selectedHash) = false) and (isRowSolved = false)) do 
            begin

                


                if(hashSum(tempSelected, matrix[targetRow]) > row[targetRow]) then
                begin   
                    tempSelected := ansHash;
          
                end;
                
                otherBig := selectNewHighest(matrix[targetRow], selectedHash);
                
                //Update Selected base
                for i := 1 to 5 do
                    begin
                        if(otherBig[i] = true) then 
                        begin
                            selectedHash[i] := true;
                            tempSelected[i] := true;
                        end;
                    end;

                if(hashSum(tempSelected,matrix[targetRow]) = row[targetRow]) then
                begin
                    isRowSolved := true;

                    ansHash := tempSelected;
                                    
                end
                else if(hashSum(tempSelected,matrix[targetRow]) < row[targetRow]) then
                begin
                    ansHash := tempSelected;
                end;
                // delay(500);
            end;
        end;

    end; // End of main while

    //Check if row is solved
    if(isRowSolved)then  
    begin
        maskMatrix[targetRow] := ansHash;
        GotoXY(TempX,TempY);
        write('Solusi Baris - ');
        write(targetRow);
        TempY := TempY + 1;
        printHashNumberArray(ansHash, TempX, TempY,TargetRow);

        TempY := TempY + 2;
        GotoXY(TempX,TempY);
        write('Matrix Solusi : ');
        TempY := TempY + 2;
        printAnswerMatrix(TempX,TempY);
    end;
end;

begin
    Y := 4;
    X := 11;
    TextColor(White);

    // loadFile();
    // createNumberMatrix();
    preLoad();
    GotoXY(11,Y-2);
    write('Input');
    printMatrix(11,Y);

    GotoXY(32+10,7);
    write('Tekan ');
    TextColor(13);
    write('Enter ');
    TextColor(white);
    write('Untuk Mulai Proses Solving');
    readln();


    FromTime := Now;

    GotoXY(X,Y);
    writeln('== Proses Solving ===================================================================================');

    Y := Y+2;

    getPossibleRow(1);
    getPossibleRow(2);
    getPossibleRow(3);
    getPossibleRow(4);
    getPossibleRow(5);

    GotoXY(X,Y+17);
    writeln('=====================================================================================================');
    ToTime := Now;
    DiffMinutes := MilliSecondsBetween(ToTime,FromTime);
    GotoXY(32+12,9);
    write('Solved Dalam Waktu : ');
    write(DiffMinutes:10:2);
    write(' MS');
    GotoXY(95,2);
    write('Solution : ');
    printAnswerMatrix(95,2+2);
    readln;
end.