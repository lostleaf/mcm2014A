function show_edge(v, index)
    gray = rgb2gray(v.read(index));
    edge(gray, 'canny');
end