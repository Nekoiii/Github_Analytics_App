class PaginationService
  class << self
    def do_pagination(token, query_template, page_info_path)
      cursor = nil
      has_next = true
      all_datas = []

      while has_next
        new_datas, has_next, cursor = do_pagination_has_next(token, page_info_path, cursor, query_template)
        all_datas.concat(new_datas) if new_datas.present?
      end

      Rails.logger.debug "do_pagination--xxx---: #{all_datas}"
      all_datas
    end

    private

    def do_pagination_has_next(token, page_info_path, cursor, query_template)
      # *Use ", after: \"#{cursor}\"" not ', after: "#{cursor}"' here!!!!
      query = format(query_template, after_part: cursor ? ", after: \"#{cursor}\"" : '')
      res = GithubAppService.execute_query(token, query)
      data = res['data']
      return if data.blank?

      updated_has_next = data.dig(*page_info_path, 'pageInfo', 'hasNextPage')
      updated_cursor = data.dig(*page_info_path, 'pageInfo', 'endCursor')

      edges = data.dig(*page_info_path, 'edges')
      return if edges.blank?

      new_datas = edges.map { |edge| edge['node'] }
      [new_datas, updated_has_next, updated_cursor]
    end
  end
end
