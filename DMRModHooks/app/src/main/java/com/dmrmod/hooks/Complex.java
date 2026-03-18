/*
Complex number operations
Ported from robot36 by Ahmet Inan <xdsopl@gmail.com>
*/
package com.dmrmod.hooks;

public class Complex {
    float real;
    float imag;

    Complex() {
        this.real = 0;
        this.imag = 0;
    }

    Complex(float real, float imag) {
        this.real = real;
        this.imag = imag;
    }

    Complex set(float real) {
        this.real = real;
        this.imag = 0;
        return this;
    }

    Complex set(float real, float imag) {
        this.real = real;
        this.imag = imag;
        return this;
    }

    float norm() {
        return real * real + imag * imag;
    }

    float abs() {
        return (float) Math.sqrt(norm());
    }

    float arg() {
        return (float) Math.atan2(imag, real);
    }

    Complex polar(float a, float b) {
        real = a * (float) Math.cos(b);
        imag = a * (float) Math.sin(b);
        return this;
    }

    Complex conj() {
        imag = -imag;
        return this;
    }

    Complex add(Complex other) {
        real += other.real;
        imag += other.imag;
        return this;
    }

    Complex sub(Complex other) {
        real -= other.real;
        imag -= other.imag;
        return this;
    }

    Complex mul(float value) {
        real *= value;
        imag *= value;
        return this;
    }

    Complex mul(Complex other) {
        float tmp = real * other.real - imag * other.imag;
        imag = real * other.imag + imag * other.real;
        real = tmp;
        return this;
    }

    Complex div(float value) {
        real /= value;
        imag /= value;
        return this;
    }

    Complex div(Complex other) {
        float den = other.norm();
        float tmp = (real * other.real + imag * other.imag) / den;
        imag = (imag * other.real - real * other.imag) / den;
        real = tmp;
        return this;
    }
}
