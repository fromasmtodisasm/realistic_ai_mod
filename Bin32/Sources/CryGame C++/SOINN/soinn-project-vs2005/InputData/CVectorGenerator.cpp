#include "CVectorGenerator.h"
#include <stdlib.h>
#include <math.h>

/* ----------------< CVectorGenerator >---------------- */

const double CVectorGenerator::PI = 3.141592;

CVectorGenerator::CVectorGenerator()
{
	Init();
}

CVectorGenerator::CVectorGenerator(const double noise)
{
	Init();
	SetNoise(noise);
}

CVectorGenerator::~CVectorGenerator()
{
	if (m_signal != NULL)
	{
		delete [] m_signal;
		m_signal = NULL;
	}
}

void CVectorGenerator::Init(void)
{
	m_signal    = NULL;
	m_dimension = 0;
	m_classNum  = 0;
	m_noise     = 0.0;
}

bool CVectorGenerator::GetDrawCoordinates(const double *signal, double &x, double &y)
{
	x = 0.0;
	y = 0.0;

	if (signal == NULL) return false;
	if (m_dimension <= 0) return false;

	if (m_dimension >= 1) x = signal[0];
	if (m_dimension >= 2) y = signal[1];

	return true;
}

int CVectorGenerator::GetDimension(void)
{
	return m_dimension;
}

int CVectorGenerator::GetClassNum(void)
{
	return m_classNum;
}

bool CVectorGenerator::SetNoise(double noise)
{
	if (noise < 0.0 || 1.0 <= noise) return false;

	m_noise = noise;

	return true;
}

bool CVectorGenerator::IsNoise(void)
{
	if (Random() < m_noise)
	{
		return true;
	}
	else
	{
		return false;
	}
}

double CVectorGenerator::Random(void)
{
	return (double)rand()/(double)RAND_MAX;
}

/* ----------------< CVectorGeneratorSin >---------------- */

const int CVectorGeneratorSin::DIMENSION = 2;

CVectorGeneratorSin::CVectorGeneratorSin() : CVectorGenerator()
{
	m_dimension = DIMENSION;
	m_classNum  = 1;
	if (m_signal == NULL)
	{
		m_signal = new double[m_dimension];
	}
}

double* CVectorGeneratorSin::GenerateVector(void)
{
	if (m_signal == NULL) return NULL;
	if (IsNoise())
	{
		m_signal[0] = 2.0*PI*(Random()-0.5);
		m_signal[1] = 4.0*(Random()-0.5);
	}
	else
	{
		m_signal[0] = 2.0*PI*(Random()-0.5);
		m_signal[1] = 1.5*sin(m_signal[0])+0.25*(Random()-0.5);
	}
	return m_signal;
}

/* ----------------< CVectorGeneratorGaussian >---------------- */

const int CVectorGeneratorGaussian::DIMENSION = 2;

CVectorGeneratorGaussian::CVectorGeneratorGaussian() : CVectorGenerator()
{
	m_dimension = DIMENSION;
	m_classNum  = 1;
	if (m_signal == NULL)
	{
		m_signal = new double[m_dimension];
	}
}

double* CVectorGeneratorGaussian::GenerateVector(void)
{
	if (m_signal == NULL) return NULL;
	if (IsNoise())
	{
		m_signal[0] = 8.0*(Random()-0.5);
		m_signal[1] = 8.0*(Random()-0.5);
	}
	else
	{
		double r, x, y, v, t, theta;
		if (rand()%2 == 0)
		{
			x = -1.0;
			y = -1.0;
		}
		else
		{
			x = 1.0;
			y = 1.0;
		}
		v = 1.0;
		theta = 2.0*PI*Random();
		do
		{
			r = Random();
		} while (r == 0.0);
		t = sqrt(-2.0*log(r));
		if (t < -100.0) t = -100.0;
		r = v*t*cos(2.0*PI*Random());
		m_signal[0] = x + r*cos(theta);
		m_signal[1] = y + r*sin(theta);
	}
	return m_signal;
}

/* ----------------< CVectorGeneratorConcentric >---------------- */

const int CVectorGeneratorConcentric::DIMENSION = 2;

CVectorGeneratorConcentric::CVectorGeneratorConcentric() : CVectorGenerator()
{
	m_dimension = DIMENSION;
	m_classNum  = 1;
	if (m_signal == NULL)
	{
		m_signal = new double[m_dimension];
	}
}

double* CVectorGeneratorConcentric::GenerateVector(void)
{
	if (m_signal == NULL) return NULL;
	if (IsNoise())
	{
		m_signal[0] = 8.0*(Random()-0.5);
		m_signal[1] = 8.0*(Random()-0.5);
	}
	else
	{
		double r, theta;
		if (Random() < 0.2)
		{
			r = 1.0+0.3*(Random()-0.5);
		}
		else
		{
			r = 3.0+0.3*(Random()-0.5);
		}
		theta = 2.0*PI*Random();
		m_signal[0] = r*cos(theta);
		m_signal[1] = r*sin(theta);
	}
	return m_signal;
}
