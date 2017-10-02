#include "CInputAdministrator.h"
#include "CVectorGeneratorFromFile.h"
#include <stdlib.h>

const int CInputAdministrator::NO_GENERATOR         = -1;
const int CInputAdministrator::GENERATOR_FROM_FILE  = 0;
const int CInputAdministrator::GENERATOR_SIN        = 1;
const int CInputAdministrator::GENERATOR_GAUSSIAN   = 2;
const int CInputAdministrator::GENERATOR_CONCENTRIC = 3;
const int CInputAdministrator::STATE_START = 0;
const int CInputAdministrator::STATE_STOP  = 1;

CInputAdministrator::CInputAdministrator()
{
	m_pVectorGenerator         = NULL;
	m_pVectorGeneratorFromFile = NULL;
	m_generatorType  = NO_GENERATOR;
	m_generatorState = STATE_START;
	m_inputNum = 0;
	m_noise = 0.0;
}

CInputAdministrator::~CInputAdministrator()
{
	if (m_pVectorGenerator == NULL)
	{
		delete m_pVectorGenerator;
		m_pVectorGenerator = NULL;
	}
	if (m_pVectorGeneratorFromFile == NULL)
	{
		delete m_pVectorGeneratorFromFile;
		m_pVectorGeneratorFromFile = NULL;
	}
}

double* CInputAdministrator::GenerateVector(void)
{
	double *signal;

	if (m_generatorState == STATE_STOP) return NULL;

	if (m_generatorType != GENERATOR_FROM_FILE)
	{
		if (m_pVectorGenerator == NULL) return NULL;
		signal = m_pVectorGenerator->GenerateVector();
	}
	else
	{
		if (m_pVectorGeneratorFromFile == NULL) return NULL;
		signal = m_pVectorGeneratorFromFile->GenerateVector();
	}
	if (signal == NULL) return NULL;

	m_inputNum++;
	return signal;
}

bool CInputAdministrator::GetDrawCoordinates(const double *signal, double &x, double &y)
{
	x = 0.0;
	y = 0.0;

	if (signal == NULL) return false;

	if (m_generatorType != GENERATOR_FROM_FILE)
	{
		if (m_pVectorGenerator == NULL) return false;
		return m_pVectorGenerator->GetDrawCoordinates(signal, x, y);
	}
	else
	{
		if (m_pVectorGeneratorFromFile == NULL) return false;
		return m_pVectorGeneratorFromFile->GetDrawCoordinates(signal, x, y);
	}
}

bool CInputAdministrator::SetNoise(double noise)
{
	if (noise < 0.0 || 1.0 <= noise) return false;

	m_noise = noise;

	if (m_generatorType != GENERATOR_FROM_FILE)
	{
		if (m_pVectorGenerator == NULL) return false;
		return m_pVectorGenerator->SetNoise(noise);
	}
	else
	{
		if (m_pVectorGeneratorFromFile == NULL) return false;
		return m_pVectorGeneratorFromFile->SetNoise(noise);
	}
}

void CInputAdministrator::ResetInputNum(void)
{
	m_inputNum = 0;
}

bool CInputAdministrator::SetGeneratorType(const int type)
{
	if (m_generatorType == type) return false;

	if (m_pVectorGenerator != NULL)
	{
		delete m_pVectorGenerator;
		m_pVectorGenerator = NULL;
	}
	if (m_pVectorGeneratorFromFile != NULL)
	{
		delete m_pVectorGeneratorFromFile;
		m_pVectorGeneratorFromFile = NULL;
	}
	m_inputNum = 0;

	switch (type)
	{
	case GENERATOR_FROM_FILE:
		m_pVectorGeneratorFromFile = new CVectorGeneratorFromFile();
		m_generatorType = GENERATOR_FROM_FILE;
		break;
	case GENERATOR_SIN:
		m_pVectorGenerator = new CVectorGeneratorSin();
		m_generatorType = GENERATOR_SIN;
		break;
	case GENERATOR_GAUSSIAN:
		m_pVectorGenerator = new CVectorGeneratorGaussian();
		m_generatorType = GENERATOR_GAUSSIAN;
		break;
	case GENERATOR_CONCENTRIC:
		m_pVectorGenerator = new CVectorGeneratorConcentric();
		m_generatorType = GENERATOR_CONCENTRIC;
		break;
	default:
		m_generatorType = NO_GENERATOR;
		return false;
	}

	if (m_generatorType != GENERATOR_FROM_FILE)
	{
		m_pVectorGenerator->SetNoise(m_noise);
	}
	else
	{
		m_pVectorGeneratorFromFile->SetNoise(m_noise);
	}

	return true;
}

int CInputAdministrator::GetGeneratorType(void)
{
	return m_generatorType;
}

bool CInputAdministrator::SetGeneratorState(const int state)
{
	switch (state)
	{
		case STATE_START:
			m_generatorState = STATE_START;
			break;
		case STATE_STOP:
			m_generatorState = STATE_STOP;
			break;
		default:
			return false;
	}

	return true;
}

int CInputAdministrator::GetGeneratorState(void)
{
	return m_generatorState;
}

int CInputAdministrator::GetDimension(void)
{	
	if (m_generatorType != GENERATOR_FROM_FILE)
	{
		if (m_pVectorGenerator == NULL) return 0;
		return m_pVectorGenerator->GetDimension();
	}
	else
	{
		if (m_pVectorGeneratorFromFile == NULL) return 0;
		return m_pVectorGeneratorFromFile->GetDimension();
	}
}

int CInputAdministrator::GetInputNum(void)
{
	return m_inputNum;
}

CVectorGeneratorFromFile* CInputAdministrator::GetGeneratorFromFile(void)
{
	if (m_generatorType != GENERATOR_FROM_FILE) return NULL;

	return m_pVectorGeneratorFromFile;
}
