function x = x_gen(we)

yPF = we(1);
yF = we(2);
uF = we(3);
p1 = we(4);
p2 = we(5);
p3 = we(6);
phi = [-yPF -yF uF]';
phat_RIV = [p1 p2 p3]';
x = phi'*phat_RIV;
end

