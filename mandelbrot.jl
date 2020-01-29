# julia -p $(sysctl -n hw.ncpu) -i mandelbrot.jl

const N_HEIGHT = 100
const N_WIDTH = 1.5 * N_HEIGHT
const X0 = -2
const X1 = 1
const Y0 = -1
const Y1 = 1

@everywhere function converge(x)
	z = 0
	i = 0
	while i < 100 && abs(z) < 2
		z = z ^ 2 + x
		i += 1
	end
	return i
end

function coordinates(i, j)
	( (X0 + i * (X1 - X0) / N_WIDTH)
	+ (Y0 + j * (Y1 - Y0) / N_HEIGHT) * 1im)
end

M = [ coordinates(i, j) for i = 1:N_HEIGHT, j = 1:N_WIDTH]

img = pmap(converge, M);

println(size(img))
