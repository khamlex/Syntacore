%----Name (path, if located in a different directory) of the input file----
file_input = 'input.txt';

%----Name (path, if you need to display in a different directory) of the output file----
file_output = 'output.txt';

%----Reading data from a file----
Data_row = fileread(file_input);
Data_len = length(Data_row);
rows = linecount(file_input);

W = [];
for i = 1:Data_len
    if Data_row(i:i) == 48 || Data_row(i:i) == 49
        W = [W, Data_row(i:i) - 48];
    end
end

n = 1;
Data_len = length(W);
columns = Data_len/rows;
B = zeros(rows, columns);
for i = 1:rows
    for j = 1:columns
        B(i, j) = W(n:n);
        n = n + 1;
    end
end

%----Weights matrix creation----
C = zeros(2^rows, rows);
for i = 1:2^rows
    out = binary2vector(i - 1, rows);
    for j = 1:rows
        C(i, j) = out(j);
    end
end

%----Finding all possible linear combinations----
columns = length(B(1, :));
D = sum(mod(C*B, 2), 2);
Results = zeros(2, columns + 1);
for i = 1:columns + 1
    Results(1, i) = i-1;
end
for i = 1:length(D)
    Results(2, D(i)+1) = Results(2, D(i)+1) + 1;
end

%----Writing an answer to a file----
writematrix(Results.', file_output, 'Delimiter',' ')

%----Number of lines in the file----
function n = linecount(filename)
    fid = fopen(filename);
    n = 0;
    while true
        t = fgetl(fid);
        if ~ischar(t)
            break;
        else
            n = n + 1;
        end
    end
    fclose(fid);
end

%----Binary translation----
function out = binary2vector(data,nBits)
    powOf2 = 2.^[0:nBits-1];
    out = false(1,nBits);
    ct = nBits;
    while data > 0
        if data >= powOf2(ct)
            data = data - powOf2(ct);
            out(ct) = true;
        end
        ct = ct - 1;
    end
end