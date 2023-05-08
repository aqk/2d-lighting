# Thanks: https://scipython.com/blog/poisson-disc-sampling-in-python/
import math
import numpy as np

class PoissonDisc:
    def __init__(self, perlin, opts):
        self.perlin = perlin
        self.k = opts['k'] if 'k' in opts else 30
        self.width = opts['width'] if 'width' in opts else 256
        self.height = opts['height'] if 'height' in opts else 256
        self.a = opts['side'] if 'side' in opts else self.r / math.sqrt(2)
        self.mindist = opts['mindist'] if 'mindist' in opts else 3.0
        self.mindist_fun = opts['minf'] if 'minf' in opts else lambda x,y: min(self.mindist, self.mindist + 50.0 * self.perlin([x/self.width, y/self.width]) * self.mindist)
        self.r = self.mindist
        coords_list = [(ix, iy) for ix in range(self.width) for iy in range(self.height)]
        self.cells = {coords: None for coords in coords_list}
        self.samples = None

    def get_cell_coords(self,pt):
        return int(pt[0] // self.a), int(pt[1] // self.a)

    def get_neighbours(self, coords):
        dxdy = [(-1,-2),(0,-2),(1,-2),(-2,-1),(-1,-1),(0,-1),(1,-1),(2,-1),
            (-2,0),(-1,0),(1,0),(2,0),(-2,1),(-1,1),(0,1),(1,1),(2,1),
            (-1,2),(0,2),(1,2),(0,0)]

        neighbours = []

        for dx, dy in dxdy:
            neighbour_coords = coords[0] + dx, coords[1] + dy
            if not (0 <= neighbour_coords[0] < self.width and
                    0 <= neighbour_coords[1] < self.height):
                # We're off the grid: no neighbours here.
                continue
            neighbour_cell = self.cells[neighbour_coords]
            if neighbour_cell is not None:
                # This cell is occupied: store this index of the contained point.
                neighbours.append(neighbour_cell)

        return neighbours

    def point_valid(self, pt):
        cell_coords = self.get_cell_coords(pt)
        mindist_at = self.mindist_fun(pt[0]/self.width,pt[1]/self.height)
        for idx in self.get_neighbours(cell_coords):
            nearby_pt = self.samples[idx]
            # Squared distance between or candidate point, pt, and this nearby_pt.
            distance2 = (nearby_pt[0]-pt[0])**2 + (nearby_pt[1]-pt[1])**2
            if distance2 < mindist_at:
                # The points are too close, so pt is not a candidate.
                return False
        # All points tested: if we're here, pt is valid
        return True

    def get_point(self, refpt):
        i = 0
        while i < self.k:
            i += 1
            rho = np.sqrt(np.random.uniform(self.mindist, 4.0 * self.mindist))
            theta = np.random.uniform(0, 2*np.pi)
            pt = refpt[0] + rho*np.cos(theta), refpt[1] + rho*np.sin(theta)
            if not (0 <= pt[0] < self.width and 0 <= pt[1] < self.height):
                # This point falls outside the domain, so try again.
                continue
            if self.point_valid(pt):
                return pt

        # We failed to find a suitable point in the vicinity of refpt.
        return False

    def scatter_points(self):
        # Pick a random point to start with.
        pt = (np.random.uniform(0, self.width), np.random.uniform(0, self.height))
        self.samples = [pt]
        # Our first sample is indexed at 0 in the samples list...
        self.cells[self.get_cell_coords(pt)] = 0
        # ... and it is active, in the sense that we're going to look for more points
        # in its neighbourhood.
        active = [0]

        nsamples = 1
        # As long as there are points in the active list, keep trying to find samples.
        while active:
            # choose a random "reference" point from the active list.
            idx = np.random.choice(active)
            refpt = self.samples[idx]
            # Try to pick a new point relative to the reference point.
            pt = self.get_point(refpt)
            if pt:
                # Point pt is valid: add it to the samples list and mark it as active
                self.samples.append(pt)
                nsamples += 1
                active.append(len(self.samples)-1)
                self.cells[self.get_cell_coords(pt)] = len(self.samples) - 1
            else:
                # We had to give up looking for valid points near refpt, so remove it
                # from the list of "active" points.
                active.remove(idx)

        return filter(lambda x: x[1] is not None, self.cells.items())
