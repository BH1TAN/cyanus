CYANUS (a Calculator for Yield Analysis of NeUtron Activation)
====

CYANUS is a MATLAB tool for calculating the energies and intensities of delayed gamma-rays released by neutron irradiated samples. 

CYANUS allows the user to arbitrarily designate the pointwised neutorn spectrum, elemental composition of the irradiation sample and the three key time duration (irradiation, cooling and measurement time). 

![image](https://github.com/BH1TAN/cyanus/tree/main/image/input_output.png)

## Quick start
1. Add the folder "function" to Matlab search path.
2. Run `cyanus()` in the command window, several input forms to run CYANUS will appear. 
3. Results are saved to `cyanus-output.mat` in the working path. The variable `table_gamma` shows all the possible delayed gamma-rays and their count in the measurement time period.

## Highlight
1. Pointwised neutron spectra are avaliable.
2. The isomer production ratios for isotopes irradiated by neutrons with different energies are taken into consideration.
3. Easy to deploy, add the folder to the Matlab path, then start the work.

## Introduction
When irradiated by neutrons, the stable isotope $^AX$ may capture a neutron and form the isotope $^{A+1,s}X$ ($s$ represents the long lived state, $g$ for ground state, $m1$ for the first isomer and $m2$ for the second isomer). The production rate is
$$
\frac{dN}{dt}=N_0R_{I,s}\int\sigma(E)\phi(E)dE-\lambda N
$$
In which
    $N$ = The number of $^{A+1,s}X$ in the sample
    $N_0$ = The number of $^AX$ in the sample
    $R_{I,s}$ = The isomeric ratio (the probability of producing isomer $^{A+1,s}X$ after $^AX$ absorbs a neutron). It is also used for standing for the ratio to form the ground state nucleus, which is definitely not an isomer, for the convenience.
    $\sigma(E)$ = The (n, γ) cross section of $^AX$ for neutrons with energy  
    $\phi(E)$ = The flux of irradiating neutrons with energy from $E$ to $E+dE$
    $\lambda$ = The decay constant of $^{A+1,s}X$

After an irradiation time of $t_{irr}$ , the amount of the radioactive isotopes $^{A+1,s}X$ will be 

$$
N(t=t_{irr}) = \frac{N_0R_{I,s}\int\sigma(E)\phi(E)dE}{\lambda} (1-e^{-\lambda t_{irr}})
$$

The count $C_{\gamma}$ of gamma-ray with energy $E_{\gamma}$ released by $^{A+1,s}X$ during the time period [$t_{cool}$ , $t_{cool}+t_{meas}$ ] after the irradiation could be calculated as

$$
C_{\gamma}=N(t=t_{irr})\Gamma_{\gamma}e^{-\lambda t_{cool}}(1-e^{-\lambda t_{meas}})
$$

In which
    $\Gamma_{\gamma}$ = the intensity of gamma-ray with energy of $E_\gamma$ along with the decay of a $^{A+1,s}X$

CYANUS integrated above mentioned equations for calculating $C_{\gamma}$ for all 5730 gamma-rays released by 289 stable isotopes (74 stable elements). For each of the gamma-ray, following table lists the 9 parameters needs to be defined and their source. 

| Symbol | Description | Source |
|-------|-------|--------|
| $N_0$ | The number of $^AX$ in the sample | User input |
| $R_{I,s}$ | The isomeric ratio | Calculated by [TALYS 1.96](https://tendl.web.psi.ch/tendl_2021/talys.html) |
| $\sigma(E)$ | The (n, γ) cross section of $^AX$ for neutrons with energy | [ENDF/B-VII.1](https://www-nds.iaea.org/exfor/endf.htm) |
| $\phi(E)$ | The flux of irradiating neutrons with energy from $E$ to $E+dE$ | User input |
| $\lambda$ | The decay constant of $^{A+1,s}X$ | [NUBASE2020](https://www-nds.iaea.org/relnsd/nubase/nubase_min.html) |
| $\Gamma_{\gamma}$ | the intensity of gamma-ray with energy of $E_\gamma$ along with the decay of a $^{A+1,s}X$ | [Lund/LBNL Nuclear Data Search](http://nucleardata.nuclear.lu.se/toi/nucSearch.asp) |
| $t_{irr}$ | The irradiation time | User input |
| $t_{cool}$ | The cooling time | User input |
| $t_{meas}$ | The measurement time | User input |

The nuclear data from the databases were downloaded and organized in the folder `data`



## About CYANUS
As an elementary work for aiding the neutron activation analysis with complex neutron fields, CYANUS requires abundant tests to become reliable. We sincerely thank you for using and cross checking CYANUS. Any comments are welcome.



中子活化特征伽马射线计算程序CYANUS
====

CYANUS 是一个使用Matlab编写的小工具，用以计算中子活化后，样品发射的缓发伽马射线能量及强度。用户可自由输入样品元素组成、辐照中子能谱、照射时长、冷却时长和测量时长，程序将基于核数据，计算并输出辐照后的物体释放的所有的缓发伽马射线能量和数量信息。相比类似功能的软件，CYANUS主要有三大亮点：一是中子能谱输入自由度更高，可逐能量点指定注量率，而不局限于传统的热中子注量率、快热中子比等若干个参数；二是考虑了同质异能素的生成概率与中子能量的依赖关系；三是软件可全离线使用，便于与其它科研代码互相调用和组合。

![image](https://github.com/BH1TAN/cyanus/tree/main/image/input_output2.png)

