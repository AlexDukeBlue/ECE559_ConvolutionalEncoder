len1 = 6144;
len2 = 1056;

%create rand int that is either 0 or 1 (2-1=1, 1-1=0)
x=randi(2, 1, len2) - 1;

%save bitsream so is not lost
bits = fopen('bitstream', 'w');
fprintf(bits, '%d', x);
fclose(bits);

%x=[0 0 0 1 1 1 1 1];
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
cout = [x(length(x)-6) x(length(x)-5) x(length(x)-4) x(length(x)-3) x(length(x) -2) x(length(x)-1) x(length(x))];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile, '%s : %d%d%d; \n' , n1, dout0, dout1, dout2)
count=count+1; 

%create second dout, one "new" bit
cout = [x(bit1) x(length(x)-6) x(length(x)-5) x(length(x)-4) x(length(x)-3) x(length(x) -2) x(length(x)-1)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2)
count=count+1;

%create third dout, two "new" bit
cout = [ x(bit2) x(bit1) x(length(x)-6) x(length(x)-5) x(length(x)-4) x(length(x)-3) x(length(x) -2)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2)
count=count+1;

%create fourth dout, three "new" bit
cout = [x(bit3) x(bit2) x(bit1) x(length(x)-6) x(length(x)-5) x(length(x)-4) x(length(x)-3)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2)
count=count+1;

%create fifth dout, four "new" bit
cout = [x(bit4) x(bit3) x(bit2) x(bit1) x(length(x)-6) x(length(x)-5) x(length(x)-4)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2)
count=count+1;

%create sixth dout, five "new" bit
cout = [x(bit5) x(bit4) x(bit3) x(bit2) x(bit1) x(length(x)-6) x(length(x)-5)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2)
count=count+1;

%create seventh dout, six "new" bit
cout = [x(bit5) x(bit4) x(bit3) x(bit2) x(bit1) x(length(x)-6) x(length(x)-5)];
dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
n1=dec2bin(count,13);
fprintf(outputFile,'%s : %d%d%d; \n' , n1, dout0, dout1, dout2)
count=count+1;


for p=1:length(x)
    cout = [x(bit7) x(bit6) x(bit5) x(bit4) x(bit3) x(bit2) x(bit1)];
    dout0 = bitxor(bitxor(bitxor(cout(1), cout(3)), bitxor(cout(4), cout(6))), cout(7));
    dout1 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(4))), cout(7));
    dout2 = bitxor(bitxor(bitxor(cout(1), cout(2)), bitxor(cout(3), cout(5))), cout(7));
    dout = [dout0 dout1 dout2];
    n2=dec2bin(count,13);
    
    fprintf(outputFile,'%s : %d%d%d; \n' , n2, dout0, dout1, dout2)
    bit7 = bit7+1;
    bit6 = bit6+1;
    bit5 = bit5+1;
    bit4 = bit4+1;
    bit3 = bit3+1;
    bit2 = bit2+1;
    bit1 = bit1+1;
    count=count+1;

    
end


fclose(outputFile);
    