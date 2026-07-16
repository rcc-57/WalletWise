export const supportedCurrencies = [
  {
    value: 'USD',
    label: 'USD — US Dollar'
  },
  {
    value: 'EUR',
    label: 'EUR — Euro'
  },
  {
    value: 'GBP',
    label: 'GBP — British Pound'
  },
  {
    value: 'CNY',
    label: 'CNY — Chinese Yuan'
  },
  {
    value: 'RUB',
    label: 'RUB — Russian Ruble'
  }
]

export function formatMoney(
  value,
  currency
) {
  const numericValue = Number(value || 0)

  if (!currency) {
    return new Intl.NumberFormat(
      'en-US',
      {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      }
    ).format(numericValue)
  }

  return new Intl.NumberFormat(
    'en-US',
    {
      style: 'currency',
      currency,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }
  ).format(numericValue)
}

export function getCurrencyLabel(
  currency
) {
  if (!currency) {
    return ''
  }

  const item = supportedCurrencies.find(
    (currencyItem) =>
      currencyItem.value === currency
  )

  return item?.label || currency
}