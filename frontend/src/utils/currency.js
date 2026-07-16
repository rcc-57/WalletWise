export const CURRENCY_OPTIONS = [
  {
    code: 'USD',
    value: 'USD',
    symbol: '$',
    label: 'USD — US Dollar ($)',
  },
  {
    code: 'EUR',
    value: 'EUR',
    symbol: '€',
    label: 'EUR — Euro (€)',
  },
  {
    code: 'GBP',
    value: 'GBP',
    symbol: '£',
    label: 'GBP — British Pound (£)',
  },
  {
    code: 'CNY',
    value: 'CNY',
    symbol: '¥',
    label: 'CNY — Chinese Yuan (¥)',
  },
  {
    code: 'RUB',
    value: 'RUB',
    symbol: '₽',
    label: 'RUB — Russian Ruble (₽)',
  },
]

// Дополнительные экспорты оставлены для совместимости
// с существующими компонентами.
export const SUPPORTED_CURRENCIES = CURRENCY_OPTIONS
export const supportedCurrencies = CURRENCY_OPTIONS

export function getCurrencyLabel(currency) {
  const selectedCurrency = CURRENCY_OPTIONS.find(
    (item) => item.code === currency,
  )

  return selectedCurrency?.label ?? currency ?? ''
}

export function getCurrencySymbol(currency) {
  const selectedCurrency = CURRENCY_OPTIONS.find(
    (item) => item.code === currency,
  )

  return selectedCurrency?.symbol ?? ''
}

export function formatMoney(value, currency = 'USD') {
  const numericValue = Number(value)

  if (!Number.isFinite(numericValue)) {
    return ''
  }

  const supportedCurrency = CURRENCY_OPTIONS.some(
    (item) => item.code === currency,
  )
    ? currency
    : 'USD'

  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: supportedCurrency,
    currencyDisplay: 'narrowSymbol',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(numericValue)
}