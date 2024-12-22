# Earthquake Simulation of a Single-Storey Building

This repository contains MATLAB files, Simulink models, and GUI (.fig and .m files) to simulate the dynamic behavior of a single-storey building subjected to earthquake excitation. The project demonstrates the analysis and animation of a mass-spring-damper system, representing the building's vibrational response.

---

## 📁 Project Structure
- **`GUI Files (.fig, .m)`**: Implements a MATLAB GUI for user interaction to input system parameters (mass, stiffness, damping, etc.), visualize results, and animate the vibrational response. 
- **`Simulink Models`**: Provides dynamic simulation and visualization of the system using Simulink, supporting further analysis and experimentation.
- **`Scripts (.m)`**: MATLAB scripts for system modeling, state-space analysis, and plotting displacement-time profiles.

---

## 🛠 Features
1. **Graphical User Interface (GUI)**: Allows users to input parameters such as mass, damping coefficient, stiffness, acceleration, and frequency. Outputs include:
   - Displacement vs. time graph.
   - Animation of a mass-spring-damper system with earthquake excitation.
2. **Simulink Models**: Enables block-level simulation for real-time system analysis.
3. **Dynamic Animation**: Visualizes the vibrational response of the building via a spring-damper animation.
4. **Custom Inputs**: Default values for parameters are set for user convenience, but they can be customized.

---

## ⚙️ Methodology
1. **System Modeling**:  
   The building is modeled as a Single-Degree-of-Freedom (SDOF) system using:
   - Spring for stiffness
   - Damper for energy dissipation
   - Mass for dynamic analysis

2. **State-Space Representation**:  
   The system's equations of motion are solved in state-space form:
   \[
   \mathbf{A} = \begin{bmatrix}
   0 & 1 \\ 
   -\frac{k}{m} & -\frac{c}{m}
   \end{bmatrix}, \quad
   \mathbf{B} = \begin{bmatrix}
   0 \\ 
   \frac{1}{m}
   \end{bmatrix}, \quad
   \mathbf{C} = \begin{bmatrix}
   1 & 0
   \end{bmatrix}, \quad
   \mathbf{D} = 0
   \]
   
3. **Numerical Integration**:  
   MATLAB's `ode45` solver is used to compute the displacement-time response of the system under sinusoidal earthquake acceleration.

4. **Animation**:  
   An animated spring-damper system shows the real-time response of the building.

---

## 📦 Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/fatehmehmood123/earthquake_simulation.git
