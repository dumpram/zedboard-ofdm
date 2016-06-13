function [ result ] = bits_from_qpsk( qpsk_symbol )
%BITS_FROM_QPSK Summary of this function goes here
%   Detailed explanation goes here

if real(qpsk_symbol) > 0
    if imag(qpsk_symbol) > 0
        bitmask = 0;
    else
        bitmask = 1;
    end
else
    if imag(qpsk_symbol) > 0
        bitmask = 2;
    else
        bitmask = 3;
    end
end

result = int16(bitmask);

end

