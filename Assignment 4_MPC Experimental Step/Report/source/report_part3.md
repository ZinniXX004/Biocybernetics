# CHAPTER III. CONCLUSION

I discretised the continuous state-space models of Problem 1 with the bilinear transformation of the lecture, $A_d=(I-\tfrac{T}{2}A)^{-1}(I+\tfrac{T}{2}A)$ and $B_d=(I-\tfrac{T}{2}A)^{-1}B\,T/(1-T/2)$. With $T=0.001$ s the Delphi program reproduces every printed digit of $A_d$ and $B_d$ on the sheet, while the standard form with $T$ alone differs by exactly $T/2$. The factor $1/(1-T/2)$ comes from evaluating $(z+1)/2$ at the image of $s=1$ rad/s and scales the input gain. System 1 keeps its unstable pole ($z=1.002$), and system 2 keeps its undamped poles on the unit circle ($|z|=1$ to $10^{-16}$), so its step and impulse responses follow $0.5\sin2t$ and $\cos2t$.

For Problem 2 the step data of $\ddot x=-0.5\dot x-x+u$ at $T=0.1$ s were turned into Markov parameters, a $4\times4$ Hankel matrix and its SVD, which I computed with my own one-sided Jacobi method. The singular values 0.1379 and 0.0132 followed by rounding noise give the order 2, and the realisation $A=[1.2009\ -0.2486;\ 0.2486\ 0.7407]$, $B=[-0.1152;\ 0.0903]$, $C=[-0.1152\ -0.0903]$, $D=0$ reproduces the data within $10^{-13}$ and is the plant of Problem 3 to three decimals. All process data and the model are saved to a .dat file. The lecturer's program, released after the first submission, identifies the same plant from data that it integrates with the Runge-Kutta-Nyström method, and it gives the same observer gain.

For Problem 3 matching the coefficients of $\det(\lambda I-(A-K_{ob}C))$ with $(\lambda-p_1)(\lambda-p_2)$ gives two linear equations, whose solution $K_1=(\alpha m_{22}-C_2\beta)/\det M$ and $K_2=(C_1\beta-m_{21}\alpha)/\det M$ exists whenever the plant is observable. For the poles 0.8 and 0.7 the observer gain is $K_{ob}=[-2.4926;\ -1.7150]$, and the observer error falls below 1 % within 25 samples while the open-loop model is still off by 35 % after 30 samples.

# REFERENCES

::: {custom-style="Reference"}
@@REFS@@
:::
