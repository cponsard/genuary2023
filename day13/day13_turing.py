import matplotlib.pyplot as plt
import numpy as np

# I'm using seaborn for it's fantastic default styles
import seaborn as sns
sns.set_style("whitegrid")

#matplotlib inline
#load_ext autoreload
#autoreload 2

from tutils import BaseStateSystem

def laplacian1D(a, dx):
    return (
        - 2 * a
        + np.roll(a,1,axis=0)
        + np.roll(a,-1,axis=0)
    ) / (dx ** 2)

def laplacian2D(a, dx):
    return (
        - 4 * a
        + np.roll(a,1,axis=0)
        + np.roll(a,-1,axis=0)
        + np.roll(a,+1,axis=1)
        + np.roll(a,-1,axis=1)
    ) / (dx ** 2)


class OneDimensionalDiffusionEquation(BaseStateSystem):
    def __init__(self, D):
        self.D = D
        self.width = 1000
        self.dx = 10 / self.width
        self.dt = 0.9 * (self.dx ** 2) / (2 * D)
        self.steps = int(0.1 / self.dt)

    def initialise(self):
        self.t = 0
        self.X = np.linspace(-5, 5, self.width)
        self.a = np.exp(-self.X ** 2)

    def update(self):
        for _ in range(self.steps):
            self.t += self.dt
            self._update()

    def _update(self):
        La = laplacian1D(self.a, self.dx)
        delta_a = self.dt * (self.D * La)
        self.a += delta_a

    def draw(self, ax):
        ax.clear()
        ax.plot(self.X, self.a, color="r")
        ax.set_ylim(0, 1)
        ax.set_xlim(-5, 5)
        ax.set_title("t = {:.2f}".format(self.t))


#one_d_diffusion = OneDimensionalDiffusionEquation(D=1)
#one_d_diffusion.plot_time_evolution("diffusion.gif")


class ReactionEquation(BaseStateSystem):
    def __init__(self, Ra, Rb):
        self.Ra = Ra
        self.Rb = Rb
        self.dt = 0.01
        self.steps = int(0.1 / self.dt)

    def initialise(self):
        self.t = 0
        self.a = 0.1
        self.b = 0.7
        self.Ya = []
        self.Yb = []
        self.X = []

    def update(self):
        for _ in range(self.steps):
            self.t += self.dt
            self._update()

    def _update(self):
        delta_a = self.dt * self.Ra(self.a, self.b)
        delta_b = self.dt * self.Rb(self.a, self.b)

        self.a += delta_a
        self.b += delta_b

    def draw(self, ax):
        ax.clear()

        self.X.append(self.t)
        self.Ya.append(self.a)
        self.Yb.append(self.b)

        ax.plot(self.X, self.Ya, color="r", label="A")
        ax.plot(self.X, self.Yb, color="b", label="B")
        ax.legend()

        ax.set_ylim(0, 1)
        ax.set_xlim(0, 5)
        ax.set_xlabel("t")
        ax.set_ylabel("Concentrations")


#alpha, beta = 0.2, 5
#def Ra(a, b): return a - a ** 3 - b + alpha
#def Rb(a, b): return (a - b) * beta
#one_d_reaction = ReactionEquation(Ra, Rb)
#one_d_reaction.plot_time_evolution("reaction.gif", n_steps=50)


def random_initialiser(shape):
    return (
        np.random.normal(loc=0, scale=0.05, size=shape),
        np.random.normal(loc=0, scale=0.05, size=shape)
    )


class OneDimensionalRDEquations(BaseStateSystem):
    def __init__(self, Da, Db, Ra, Rb,
                 initialiser=random_initialiser,
                 width=1000, dx=1,
                 dt=0.1, steps=1):
        self.Da = Da
        self.Db = Db
        self.Ra = Ra
        self.Rb = Rb

        self.initialiser = initialiser
        self.width = width
        self.dx = dx
        self.dt = dt
        self.steps = steps

    def initialise(self):
        self.t = 0
        self.a, self.b = self.initialiser(self.width)

    def update(self):
        for _ in range(self.steps):
            self.t += self.dt
            self._update()

    def _update(self):
        # unpack so we don't have to keep writing "self"
        a, b, Da, Db, Ra, Rb, dt, dx = (
            self.a, self.b,
            self.Da, self.Db,
            self.Ra, self.Rb,
            self.dt, self.dx
        )

        La = laplacian1D(a, dx)
        Lb = laplacian1D(b, dx)

        delta_a = dt * (Da * La + Ra(a, b))
        delta_b = dt * (Db * Lb + Rb(a, b))

        self.a += delta_a
        self.b += delta_b

    def draw(self, ax):
        ax.clear()
        ax.plot(self.a, color="r", label="A")
        ax.plot(self.b, color="b", label="B")
        ax.legend()
        ax.set_ylim(-1, 1)
        ax.set_title("t = {:.2f}".format(self.t))


#Da, Db, alpha, beta = 1, 100, -0.005, 10
#def Ra(a, b): return a - a ** 3 - b + alpha
#def Rb(a, b): return (a - b) * beta
#width = 100
#dx = 1
#dt = 0.001

#OneDimensionalRDEquations(
#    Da, Db, Ra, Rb,
#    width=width, dx=dx, dt=dt,
#    steps=100
#).plot_time_evolution("1dRD.gif", n_steps=150)


class TwoDimensionalRDEquations(BaseStateSystem):
    def __init__(self, Da, Db, Ra, Rb,
                 initialiser=random_initialiser,
                 width=1000, height=1000,
                 dx=1, dt=0.1, steps=1):
        self.Da = Da
        self.Db = Db
        self.Ra = Ra
        self.Rb = Rb

        self.initialiser = initialiser
        self.width = width
        self.height = height
        self.shape = (width, height)
        self.dx = dx
        self.dt = dt
        self.steps = steps

    def initialise(self):
        self.t = 0
        self.a, self.b = self.initialiser(self.shape)

    def update(self):
        for _ in range(self.steps):
            self.t += self.dt
            self._update()

    def _update(self):
        # unpack so we don't have to keep writing "self"
        a, b, Da, Db, Ra, Rb, dt, dx = (
            self.a, self.b,
            self.Da, self.Db,
            self.Ra, self.Rb,
            self.dt, self.dx
        )

        La = laplacian2D(a, dx)
        Lb = laplacian2D(b, dx)

        delta_a = dt * (Da * La + Ra(a, b))
        delta_b = dt * (Db * Lb + Rb(a, b))

        self.a += delta_a
        self.b += delta_b

    def draw(self, ax):
        ax[0].clear()
        ax[1].clear()

        ax[0].imshow(self.a, cmap='ocean') # plasma rainbow #jet
        ax[1].imshow(self.b, cmap='hsv')  # prism gnuplot brg

        ax[0].grid(b=False)
        ax[1].grid(b=False)

        ax[0].set_xticks([])
        ax[0].set_yticks([])
        ax[1].set_xticks([])
        ax[1].set_yticks([])

  #      ax[0].set_title("A, t = {:.2f}".format(self.t))
  #      ax[1].set_title("B, t = {:.2f}".format(self.t))

    def initialise_figure(self):
        fig, ax = plt.subplots(nrows=1, ncols=2, figsize=(12, 6))
        return fig, ax


Da, Db, alpha, beta = 1, 100, -0.005, 15
def Ra(a, b): return a - a ** 3 - b + alpha
def Rb(a, b): return (a - b) * beta
width = 80
dx = 1
dt = 0.001

TwoDimensionalRDEquations(
    Da, Db, Ra, Rb,
    width=width, height=width,
    dx=dx, dt=dt, steps=150
).plot_time_evolution("test.gif",300)

#.plot_evolution_outcome("test.png", n_steps=300)


def gs_initialiser(shape):
    a = np.ones(shape)
    b = np.zeros(shape)
    centre = int(shape[0] / 2)

    a[centre - 20:centre + 20, centre - 20:centre + 20] = 0.5
    b[centre - 20:centre + 20, centre - 20:centre + 20] = 0.25

    a += np.random.normal(scale=0.05, size=shape)
    b += np.random.normal(scale=0.05, size=shape)

    return a, b

# interesting parameters taken from http://www.aliensaint.com/uo/java/rd/
params = [
    [0.16, 0.08, 0.035, 0.065],
    [0.14, 0.06, 0.035, 0.065],
    [0.16, 0.08, 0.06, 0.062],
    [0.19, 0.05, 0.06, 0.062],
    [0.16, 0.08, 0.02, 0.055],
    [0.16, 0.08, 0.05, 0.065],
    [0.16, 0.08, 0.054, 0.063],
    [0.16, 0.08, 0.035, 0.06]
]

for i, param in enumerate(params):
    if (i<5): break
    if (i>5): break
    print(i)

    Da, Db, f, k = param

    def Ra(a, b): return - a * b * b + f * (1 - a)
    def Rb(a, b): return + a * b * b - (f + k) * b

    width = 200
    dx = 1
    dt = 1

    TwoDimensionalRDEquations(
        Da, Db, Ra, Rb,
        initialiser=gs_initialiser,
        width=width, height=width,
        dx=dx, dt=dt, steps=500
    ).plot_time_evolution("ev_{}.gif".format(i),200)
    #.plot_evolution_outcome("gs_{}.png".format(i), n_steps=100)

