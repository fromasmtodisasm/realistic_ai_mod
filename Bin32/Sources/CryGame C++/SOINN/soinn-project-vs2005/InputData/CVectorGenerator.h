#ifndef _VECTOR_GENERATOR_HEADER_
#define _VECTOR_GENERATOR_HEADER_

class CVectorGenerator
{
public:
	static const double PI;

public:
	CVectorGenerator();
	CVectorGenerator(const double noise);
	~CVectorGenerator();
	virtual void	Init(void);
	virtual double*	GenerateVector(void) = 0;
	virtual bool	GetDrawCoordinates(const double *signal, double &x, double &y);
	virtual int		GetDimension(void);
	virtual int		GetClassNum(void);
	virtual bool	SetNoise(const double noise);
protected:
	bool	IsNoise(void);
	double	Random(void);

protected:
	double*	m_signal;
	int		m_dimension;
	int		m_classNum;
	double	m_noise;
};

class CVectorGeneratorSin : public CVectorGenerator
{
public:
	CVectorGeneratorSin();
	double*	GenerateVector(void);

private:
	static const int DIMENSION/*=2*/;
};

class CVectorGeneratorGaussian : public CVectorGenerator
{
public:
	CVectorGeneratorGaussian();
	double*	GenerateVector(void);

private:
	static const int DIMENSION/*=2*/;
};

class CVectorGeneratorConcentric : public CVectorGenerator
{
public:
	CVectorGeneratorConcentric();
	double*	GenerateVector(void);

private:
	static const int DIMENSION/*=2*/;
};

#endif
