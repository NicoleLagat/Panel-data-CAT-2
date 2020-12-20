***CAT 2 PANEL DATA ANALYSIS FE ADM 98883
************************************************************************
clear
insheet using "C:\Users\user\Desktop\grunfeld.csv"
xtset firm year

****SUMMARY STATISTICS
tabstat i f c , statistics( mean max min sd kurtosis skewness ) by(firm) columns(statistics)


****UNIT ROOT TEST
xtunitroot fisher   i , dfuller lags(1)
***not stationary
xtunitroot fisher   f , dfuller lags(1)
***not stationary
xtunitroot fisher   c , dfuller lags(1)
***not stationary


gen dinvestments= d.i
gen dReal_Value_of_Firm= d.f
gen dReal_Value_Firm_Capital_Stock= d.c

xtunitroot fisher   dinvestments , dfuller lags(1)
***stationary
xtunitroot fisher   dReal_Value_of_Firm , dfuller lags(1)
***stationary
xtunitroot fisher   dReal_Value_Firm_Capital_Stock , dfuller lags(1)
***stationary



**************CROSS SECTIONAL DEPENDENCE TESTS
xtreg dinvestments dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock , fe
xtcsd,pesaran
***We reject the null of cross-sectional independence hence there is cross-sectional dependence and no fixed effects
***test for heteroskedacticity


**************TESTING FOR TIME EFFECTS
xtreg dinvestments dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock i.year, fe
testparm i.year
***We fail to reject the null hence there are time effects 

******DYNAMIC MODELLING*******
***IV ESTIMATION
xtivreg  dinvestments dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock (L1.dinvestments = L2.dinvestments ),fd


***DIFFERENCED GMM
xtabond2  dinvestments L.dinvestments dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock , iv(L(2/3).dinvestments L(0/2).(dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock )) noleveleq


***SYSTEM GMM
xtabond2  dinvestments L.dinvestments dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock , iv(L(2/3).dinvestments L(0/2).(dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock ))

****Two step system GMM
xtabond2  dinvestments L.dinvestments dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock , iv(L(2/3).dinvestments L(0/2).(dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock ))twostep

****Two step Differenced GMM
xtabond2  dinvestments L.dinvestments dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock , iv(L(2/3).dinvestments L(0/2).(dReal_Value_of_Firm dReal_Value_Firm_Capital_Stock ))noleveleq robust
