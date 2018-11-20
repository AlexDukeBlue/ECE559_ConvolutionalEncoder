function h = binary2hex(b)
    h = [];
    for i = 1:4:length(b)
      h = [h bits2letter(mat2str(b(i:i+3)))];  
    end
end

function c = bits2letter(bits)
    switch bits
        case '[0 0 0 0]'
            c = '0';
        case '[0 0 0 1]'
            c = '1';
        case '[0 0 1 0]'
            c = '2';
        case '[0 0 1 1]'
            c = '3';
        case '[0 1 0 0]'
            c = '4';
        case '[0 1 0 1]'
            c = '5';
        case '[0 1 1 0]'
            c = '6';
        case '[0 1 1 1]'
            c = '7';
        case '[1 0 0 0]'
            c = '8';
        case '[1 0 0 1]'
            c = '9';
        case '[1 0 1 0]'
            c = 'A';
        case '[1 0 1 1]'
            c = 'B';
        case '[1 1 0 0]'
            c = 'C';
        case '[1 1 0 1]'
            c = 'D';
        case '[1 1 1 0]'
            c = 'E';
        case '[1 1 1 1]'
            c = 'F';
    end
end