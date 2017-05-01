"""
Sage 7.4 code to generate the polynomial system for the problem
of all lines tangent to four given spheres.
This scripts runs typing sage tangents4spheres.sage at the command prompt,
provided the python interpreter of sage is extended with phcpy.
"""
def tangent_system(centers, radii, verbose=True):
    """
    Returns a tuple with the list of polynomials
    and variables for the common tangents to four
    spheres with given centers and squares of radii.
    """
    x0, x1, x2 = var('x0, x1, x2')
    t = (x0, x1, x2) 
    vt = vector(t)   # tangent vector
    normt = vt.dot_product(vt) - 1
    if verbose:
        print 'normalized tangent :'
        print normt
    x3, x4, x5 = var('x3, x4, x5')
    m = (x3, x4, x5)
    vm = vector(m)   # moment vector
    momt = vt.dot_product(vm)
    if verbose:
        print 'moment is perpendicular to tangent :'
        print momt
    eqs = [normt, momt]
    for (ctr, rad) in zip(centers, radii):
        print 'the center :', ctr
        vc = vector(ctr)
        left = vm - vc.cross_product(vt)
        equ = left.dot_product(left) - rad**2
        if verbose:
            print equ
        eqs.append(equ)
    vrs = [x0, x1, x2, x3, x4, x5]
    return eqs, vrs

def quadruples():
    """
    If each pair of the four given spheres touch each other, then the
    tangent lines connect the points where the spheres touch each other.
    In that case, the tangent lines then have multiplicity four.
    This function returns the centers and the radii of the four
    spheres as a tuple of two lists.
    """
    c0 = (+1, +1, +1)
    c1 = (+1, -1, -1)
    c2 = (-1, +1, -1)
    c3 = (-1, -1, +1)
    ctr = [c0, c1, c2, c3]
    rad = [sqrt(2) for _ in range(4)]
    return (ctr, rad)

def tostrings(eqs):
    """
    Returns the string representations of the equations
    for input to the solve of phcpy.
    """
    result = []
    for equ in eqs:
        pol = str(equ) + ';'
        result.append(pol)
    return result

def real_coordinates(vars, sols):
    """
    Given in vars the string representations of the variables
    and in sols the list of solutions in string format, returns
    the real parts of the coordinates of the solutions as tuples,
    collected in a list.
    """
    from phcpy.solutions import coordinates
    result = []
    for sol in sols:
        (names, values) = coordinates(sol)
        crd = []
        for var in vars:
            idx = names.index(var)
            nbr = values[idx].real
            crd.append((nbr if abs(nbr) > 1.e-12 else 0.0))
        result.append(tuple(crd))
    return result

def crosspoint(tan, mom, verbose=True):
    """
    Given a tangent vector and moment vector,
    computes a point, solving for m = p x t.
    """
    if verbose:
        print 't =', tan
        print 'm =', mom
    A = Matrix(RR, [[0, tan[2], -tan[1]], \
                    [-tan[2], 0, tan[0]], \
                    [tan[1], -tan[0], 0]])
    if verbose:
        print A
    sol = A\vector(RR,mom)
    if verbose:
        print 'x =', sol
    return sol

def tangent_lines(solpts):
    """
    Given the list of solution points in solpts, returns the list of 
    tuples which represent the lines.  Each tuple contains a point on 
    the line and the tangent vector.
    """
    result = []
    for point in solpts:
        print point
        tan = vector(point[0:3])
        mom = vector(point[3:6])
        pnt = crosspoint(tan, mom)
        result.append((pnt, tan))
    return result

def main():
    """
    Solves the problem of computing all tangent lines
    to four given spheres.
    """
    (ctr, rad) = quadruples()
    eqs, vrs = tangent_system(ctr, rad)
    print 'the polynomial system :'
    for equ in eqs:
        print equ
    pols = tostrings(eqs)
    for pol in pols:
        print pol
    print 'calling the solver of phcpy :'
    from phcpy.solver import solve
    sols = solve(pols, silent=True)
    print 'the solutions :'
    for sol in sols:
        print sol
    vars = ['x0', 'x1', 'x2', 'x3', 'x4', 'x5']
    pts = real_coordinates(vars, sols)
    print 'the coordinates of the solution points :'
    for point in pts:
        print point
    lines = tangent_lines(pts)
    print 'the tangent lines :'
    for line in lines:
        print line

main()
