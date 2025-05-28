module ApplicationHelper
  include Pagy::Frontend

  def default_meta_tags
    {
      site: 'iroGraphica',
      title: '万年筆・ガラスペン用インクのレビュー投稿・共有サービス',
      reverse: true,
      charset: 'utf-8',
      description: 'iroGraphicaは、万年筆・ガラスペン用インクのレビュー投稿・共有サービスです。インクのレビューを投稿したり、レビューやインクを色で検索することができます。',
      keywords: '万年筆,ガラスペン,インク,インク沼,レビュー,共有',
      canonical: 'https://irographica.com/',
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('irographica-staticOgp.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
      }
    }
  end
end
