export interface CatalogProduct {
  name: string
  type: string
  description: string
  url: string
  platforms?: string[]
}

export interface SourceLink {
  label: string
  url: string
}

export interface CatalogModel {
  name: string
  ability: string
  context: string
  pricing: string
}

export interface Provider {
  slug: string
  name: string
  englishName: string
  logoUrl: string
  logoAlt: string
  description: string
  introduction: string
  categories: string[]
  accent: string
  aura: string
  officialUrl: string
  docsUrl: string
  sourceUpdated: string
  products: CatalogProduct[]
  sourceLinks: SourceLink[]
  models: CatalogModel[]
  highlights: string[]
}

export interface CatalogArticle {
  title: string
  summary: string
  articleType: string
  contentMarkdown: string
  sourceLinks: SourceLink[]
  verifiedAt: string
}

async function readCatalogResponse<T>(response: Response): Promise<T> {
  if (!response.ok) {
    throw new Error(`目录服务请求失败：${response.status}`)
  }
  return response.json() as Promise<T>
}

export async function fetchProviders(): Promise<Provider[]> {
  return readCatalogResponse<Provider[]>(await fetch('/api/providers'))
}

export async function fetchProvider(slug: string): Promise<Provider> {
  return readCatalogResponse<Provider>(await fetch(`/api/providers/${encodeURIComponent(slug)}`))
}

export async function fetchArticle(slug: string, offeringIndex: number): Promise<CatalogArticle> {
  return readCatalogResponse<CatalogArticle>(
    await fetch(`/api/providers/${encodeURIComponent(slug)}/offerings/${offeringIndex}/article`),
  )
}
