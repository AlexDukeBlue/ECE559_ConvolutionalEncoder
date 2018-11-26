x = [1, 1, 0, 1, 0, 0, 1, 1,...
     1, 0, 1, 0, 1, 1, 1, 1,...
     0, 0, 0, 0, 1, 1, 0, 1,...
     0, 1, 1, 1, 1, 0, 1, 0];

d0Array = [];
d1Array = [];
d2Array = [];

%create variables
bit7=7;
bit6=6;
bit5=5;
bit4=4;
bit3=3;
bit2=2;
bit1=1;
cout = linspace(0,0,7);
count=0;

%open file we will write to
outputFile = fopen('address-dout', 'w');
%create first dout, all tail bits
cout = [x(bit1) x(length(x)) x(length(x)-1) x(length(x)-2) x(length(x) -3) x(length(x)-4) x(length(x)-5)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile, '%s : %d%d%d; \n' , n1, dout0, dout1, dout2);
count=count+1; 
d0Array = [d0Array dout0];
d1Array = [d1Array dout1];
d2Array = [d2Array dout2];

%create second dout, one "new" bit
cout = [x(bit2) x(bit1) x(length(x)) x(length(x)-1) x(length(x)-2) x(length(x) -3) x(length(x)-4)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2);
count=count+1;
d0Array = [d0Array dout0];
d1Array = [d1Array dout1];
d2Array = [d2Array dout2];

%create third dout, two "new" bit
cout = [ x(bit3) x(bit2) x(bit1) x(length(x)) x(length(x)-1) x(length(x)-2) x(length(x) -3)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2);
count=count+1;
d0Array = [d0Array dout0];
d1Array = [d1Array dout1];
d2Array = [d2Array dout2];

%create fourth dout, three "new" bit
cout = [x(bit4) x(bit3) x(bit2) x(bit1) x(length(x)) x(length(x)-1) x(length(x)-2)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2);
count=count+1;
d0Array = [d0Array dout0];
d1Array = [d1Array dout1];
d2Array = [d2Array dout2];

%create fifth dout, four "new" bit
cout = [x(bit5) x(bit4) x(bit3) x(bit2) x(bit1) x(length(x)) x(length(x)-1)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2);
count=count+1;
d0Array = [d0Array dout0];
d1Array = [d1Array dout1];
d2Array = [d2Array dout2];

%create sixth dout, five "new" bit
cout = [x(bit6) x(bit5) x(bit4) x(bit3) x(bit2) x(bit1) x(length(x))];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2);
count=count+1;
d0Array = [d0Array dout0];
d1Array = [d1Array dout1];
d2Array = [d2Array dout2];

for p=1:length(x) - 6
    cout = [x(bit7) x(bit6) x(bit5) x(bit4) x(bit3) x(bit2) x(bit1)];
    dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
    dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
    dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
    dout = [dout0 dout1 dout2];
    n2=dec2bin(count,13);
    d0Array = [d0Array dout0];
    d1Array = [d1Array dout1];
    d2Array = [d2Array dout2];
    
    fprintf(outputFile,'%s : %d%d%d; \n' , n2, dout0, dout1, dout2);
    bit7 = bit7+1;
    bit6 = bit6+1;
    bit5 = bit5+1;
    bit4 = bit4+1;
    bit3 = bit3+1;
    bit2 = bit2+1;
    bit1 = bit1+1;
    count=count+1; 
end

d0Bin = [];
d1Bin = [];
d2Bin = [];

for i = 1:8:length(x)
    d0Bin = [d0Bin fliplr(d0Array(i:i+7))];
    d1Bin = [d1Bin fliplr(d1Array(i:i+7))];
    d2Bin = [d2Bin fliplr(d2Array(i:i+7))];
end
d0Hex = binary2hex(d0Bin);
d1Hex = binary2hex(d1Bin);
d2Hex = binary2hex(d2Bin);
fclose(outputFile);
